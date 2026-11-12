#!/usr/bin/env bash
source "$TM_LIB"

ANS=answers/graph.txt
tm_assert_file "$ANS" "answers/graph.txt does not exist - record what the graph shows"
get() { grep -E "^$1=" "$ANS" | head -n1 | cut -d= -f2- | tr -d '[:space:]'; }
HUB=$(get hub)
CHAIN=$(get longest_chain)

tm_assert_config_has 'terraform_data"[[:space:]]+"dispatch"' "the dispatch resource must stay"
tm_assert_config_has 'ship\.sh' "dispatch must still call scripts/ship.sh"
tm_assert_config_lacks '(^|[^_])sleep[[:space:]]+[0-9]' "waiting is not ordering"
tm_assert_config_lacks '-parallelism' "limiting parallelism is not ordering"
tm_assert_config_lacks 'on_failure' "do not tolerate the failure"

# Derive the truth from the player's own graph (transitive reduction, managed resources only).
terraform graph >"$TM_TMP/graph.dot" 2>/dev/null || tm_fail "terraform graph failed"
TRUTH=$(python3 - "$TM_TMP/graph.dot" <<'PY'
import re, sys
edges = set()
for line in open(sys.argv[1]):
    m = re.search(r'"([^"]+)"\s*->\s*"([^"]+)"', line)
    if not m:
        continue
    def norm(s):
        s = s.replace("[root] ", "").replace(" (expand)", "")
        return s
    a, b = norm(m.group(1)), norm(m.group(2))
    managed = lambda x: re.match(r"^[a-z_]+\.[A-Za-z0-9_-]+$", x) and not x.startswith(("var.", "local.", "output.", "data.", "provider"))
    if managed(a) and managed(b):
        edges.add((a, b))          # a depends on b
nodes = {n for e in edges for n in e}
dependents = {n: 0 for n in nodes}
for a, b in edges:
    dependents[b] += 1
hub = sorted(dependents, key=lambda n: (-dependents[n], n))[0]
memo = {}
def depth(n):
    if n in memo:
        return memo[n]
    memo[n] = 1 + max([depth(b) for a, b in edges if a == n] or [0])
    return memo[n]
print(hub, max(depth(n) for n in nodes))
print(" ".join(f"{a}>{b}" for a, b in sorted(edges)), file=sys.stderr)
PY
)
T_HUB=${TRUTH% *}
T_CHAIN=${TRUTH##* }
[[ -n "$T_HUB" && -n "$T_CHAIN" ]] || tm_fail "could not analyse the graph"

[[ "$HUB" == "$T_HUB" ]] || tm_fail "hub='$HUB' - look at which resource appears on the right of the most arrows in terraform graph"
[[ "$CHAIN" == "$T_CHAIN" ]] || tm_fail "longest_chain='$CHAIN' - count the managed resources on the longest path in the graph of your fixed configuration"
[[ "$T_HUB" == "random_pet.batch" ]] || tm_fail "the dependency structure of the bottling line was changed more than needed"

# Ordering proof: dispatch must depend on the manifest.
if ! grep -qE 'terraform_data\.dispatch[^>]*" -> "[^"]*local_file\.manifest' "$TM_TMP/graph.dot"; then
  tm_fail "terraform graph shows no 'dispatch needs manifest' edge - the race is still there"
fi

# And a fresh apply must work from nothing, in a scratch copy.
SCRATCH="$TM_TMP/fresh"
mkdir -p "$SCRATCH"
cp ./*.tf "$SCRATCH/"
cp -R scripts "$SCRATCH/scripts"
[[ -f .terraform.lock.hcl ]] && cp .terraform.lock.hcl "$SCRATCH/"
(cd "$SCRATCH" && terraform init -input=false -no-color >/dev/null 2>&1 \
  && terraform apply -auto-approve -input=false -no-color >"$TM_TMP/fresh-apply.txt" 2>&1) \
  || { sed 's/^/   | /' "$TM_TMP/fresh-apply.txt" | tail -12; tm_fail "a fresh apply of the configuration still fails"; }
[[ -f "$SCRATCH/ship/ship.log" ]] || tm_fail "a fresh apply did not produce ship/ship.log"

tm_apply
tm_assert_no_changes
tm_assert_file_contains ship/ship.log "shipped; Manifest:" "ship/ship.log was not written by dispatch"
tm_pass "dispatch waits for the manifest; hub=$HUB, longest chain=$CHAIN"
