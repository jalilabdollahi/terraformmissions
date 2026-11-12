#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_file ci/terraform.rc "ci/terraform.rc is missing"
tm_assert_file ci/agent-setup.sh "ci/agent-setup.sh is missing"

# The workspace config must still plan real work (the cache is for this config's providers).
tm_init
tm_plan_json
creates=$(jq '[.resource_changes[]? | select(.change.actions == ["create"])] | length' "$TM_TMP/plan.json")
[[ "$creates" -ge 5 ]] || tm_fail "the farm configuration plans only $creates resources; it must stay intact"

SCRATCH="$TM_TMP/farm"
FAKEHOME="$SCRATCH/home"
mkdir -p "$FAKEHOME"

# Parse the CLI config.
python3 - "$WORKSPACE/ci/terraform.rc" "$FAKEHOME" "$SCRATCH/player.rc" "$SCRATCH/cache_dir" <<'PY' || exit 1
import re, sys
src, fakehome, out_rc, out_dir = sys.argv[1:5]
text = open(src).read()
code = "\n".join(l for l in text.splitlines() if not l.strip().startswith("#"))
m = re.search(r'^\s*plugin_cache_dir\s*=\s*"([^"]*)"', code, re.M)
if not m:
    print("❌ FAIL: ci/terraform.rc has no plugin_cache_dir setting")
    sys.exit(1)
value = m.group(1)
if value.startswith("~"):
    print("❌ FAIL: plugin_cache_dir starts with '~', which Terraform does not expand; use $HOME")
    sys.exit(1)
if not (value.startswith("$HOME/") or value.startswith("${HOME}/")):
    print("❌ FAIL: plugin_cache_dir must be a directory under $HOME so unprivileged agents can use it (got %r)" % value)
    sys.exit(1)
if not re.search(r'^\s*disable_checkpoint\s*=\s*true\s*$', code, re.M):
    print("❌ FAIL: agents must not phone home: set disable_checkpoint = true")
    sys.exit(1)
if re.search(r'provider_installation', code):
    print("❌ FAIL: do not add a provider_installation block; the farm uses the default mirror settings")
    sys.exit(1)
real = value.replace("${HOME}", fakehome).replace("$HOME", fakehome)
open(out_dir, "w").write(real)
open(out_rc, "w").write(text.replace("${HOME}", fakehome).replace("$HOME", fakehome))
PY
CACHE=$(cat "$SCRATCH/cache_dir")

# Boot an agent (in a throwaway HOME): the setup script must create the cache directory.
HOME="$FAKEHOME" bash ci/agent-setup.sh >/dev/null 2>&1
[[ -d "$CACHE" ]] || tm_fail "after ci/agent-setup.sh the cache directory named in terraform.rc does not exist (the script and the config disagree)"

# Merge with the environment's provider mirror so init works offline, then init two fresh directories.
cat "$SCRATCH/player.rc" "${TF_CLI_CONFIG_FILE:-/dev/null}" > "$SCRATCH/merged.rc"
for d in a b; do
  mkdir -p "$SCRATCH/$d"
  cp terraform.tf "$SCRATCH/$d/"
  (cd "$SCRATCH/$d" && TF_CLI_CONFIG_FILE="$SCRATCH/merged.rc" terraform init -input=false -no-color >"$SCRATCH/$d.log" 2>&1) \
    || { sed 's/^/   │ /' "$SCRATCH/$d.log"; tm_fail "terraform init failed in scratch directory $d with ci/terraform.rc"; }
done

for d in a b; do
  for prov in null local; do
    link=$(find "$SCRATCH/$d/.terraform/providers/registry.terraform.io/hashicorp/$prov" -maxdepth 2 -type l 2>/dev/null | head -1)
    [[ -n "$link" ]] || tm_fail "directory $d: the $prov provider was copied into .terraform instead of linked from the cache"
    # The provider directory is a symlink; its direct target must sit inside the cache directory
    # (the cache entry itself may be a symlink again, e.g. to a mirror).
    ok=$(python3 - "$link" "$CACHE" <<'PY'
import os, sys
link, cache = sys.argv[1], sys.argv[2]
target = os.path.join(os.path.dirname(link), os.readlink(link))
target_dir = os.path.realpath(os.path.dirname(target))
cache = os.path.realpath(cache)
print("yes" if (target_dir + os.sep).startswith(cache + os.sep) else "no")
PY
)
    [[ "$ok" == "yes" ]] || tm_fail "directory $d: the $prov provider is not linked from the plugin cache"
  done
done

tm_pass "both fresh directories link null and local from the shared cache under \$HOME"
