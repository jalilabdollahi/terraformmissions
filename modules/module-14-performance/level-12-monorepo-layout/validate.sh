#!/usr/bin/env bash
source "$TM_LIB"

COMPONENTS="interlocking timetable platform-display"
expected() {
  case "$1" in
  interlocking) printf '%s\n' 'Signal 12 holds at danger while points 7 are reversed' 'Release only after track circuit TC-4 clears' ;;
  timetable) printf '%s\n' '06:12 Cullen Junction to Bramley, platform 2' '06:40 Bramley to Cullen Junction, platform 1' ;;
  platform-display) printf '%s\n' 'Platform 2: next train 06:12 to Bramley' 'Mind the gap at car 3' ;;
  esac
}

# Repository root: no module calls, no resources.
if grep -qE '^[[:space:]]*(module|resource)[[:space:]]+"' ./*.tf 2>/dev/null; then
  tm_fail "the repository root still declares modules or resources; they belong in components/*"
fi
[[ -d modules/signal_sheet ]] || tm_fail "the shared library modules/signal_sheet must stay"

for c in $COMPONENTS; do
  d="components/$c"
  [[ -d "$d" ]] || tm_fail "$d does not exist"
  ls "$d"/*.tf >/dev/null 2>&1 || tm_fail "$d contains no .tf files"
  grep -q 'required_providers' "$d"/*.tf || tm_fail "$d has no terraform.tf with required_providers; each component is a standalone root"
  grep -qE 'source[[:space:]]*=[[:space:]]*"\.\./\.\./modules/signal_sheet"' "$d"/*.tf \
    || tm_fail "$d must call the shared library with source = \"../../modules/signal_sheet\""
  if grep -qE '(components/|\.\./(interlocking|timetable|platform-display))' "$d"/main.tf 2>/dev/null; then
    tm_fail "$d refers to another component; components must be independent"
  fi
done

# Work in a scratch copy so no state is left in the player's directories.
MONO="$TM_TMP/mono"
mkdir -p "$MONO"
python3 - "$WORKSPACE" "$MONO" <<'PY' || exit 1
import os, shutil, sys
src, dst = sys.argv[1:3]
skip_dirs = {".terraform", ".tm"}
for root, dirs, files in os.walk(src):
    dirs[:] = [d for d in dirs if d not in skip_dirs]
    rel = os.path.relpath(root, src)
    os.makedirs(os.path.join(dst, rel), exist_ok=True)
    for f in files:
        if f.endswith(".tfstate") or f.endswith(".backup") or f == "terraform.tfstate.backup":
            continue
        shutil.copy2(os.path.join(root, f), os.path.join(dst, rel, f))
PY

for c in $COMPONENTS; do
  d="$MONO/components/$c"
  (cd "$d" && terraform init -input=false -no-color >"$TM_LAST_OUT" 2>&1) || { tm_show_last; tm_fail "terraform init failed in components/$c"; }
  (cd "$d" && terraform apply -auto-approve -input=false -no-color >"$TM_LAST_OUT" 2>&1) || { tm_show_last; tm_fail "terraform apply failed in components/$c"; }
  f="$d/out/$c.txt"
  [[ -f "$f" ]] || tm_fail "components/$c did not write out/$c.txt"
  [[ "$(cat "$f")" == "$(expected "$c")" ]] || tm_fail "components/$c/out/$c.txt does not contain the original signal lines"
  n=$(ls "$d/out" | grep -c .)
  [[ "$n" == "1" ]] || tm_fail "components/$c wrote $n files; it must own exactly its own sheet"
  [[ -f "$d/terraform.tfstate" ]] || tm_fail "components/$c has no state file of its own"
  states=$(cd "$d" && terraform state list 2>/dev/null)
  [[ "$(grep -c . <<<"$states")" == "1" ]] || tm_fail "components/$c state holds more than its own sheet"
  code=$(cd "$d" && terraform plan -detailed-exitcode -input=false -no-color >"$TM_LAST_OUT" 2>&1; echo $?)
  [[ "$code" == "0" ]] || tm_fail "components/$c does not plan clean after apply"
done

tm_init
tm_pass "three standalone components, each with its own state, built from modules/signal_sheet"
