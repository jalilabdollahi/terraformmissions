#!/usr/bin/env bash
source "$TM_LIB"

SHAPER=$(tm_recall shaper)
[[ -n "$SHAPER" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

HAS_FOREACH=$(python3 - <<'PY'
import glob, re
text = "\n".join(open(f).read() for f in glob.glob("*.tf"))
text = re.sub(r"#.*", "", text)
ok = any(re.search(r"for_each\s*=", m.group(1)) and "each." in m.group(1) for m in re.finditer(r"import\s*\{([^}]*)\}", text))
print("yes" if ok else "no")
PY
)
[[ "$HAS_FOREACH" == "yes" ]] || tm_fail "import every ticket with one import block that uses for_each and each.key / each.value"

# The loop must be driven by the variable, so a new ticket in the map is adopted too.
EXTRA='legacy_tickets={longboard="4021,1000,9999",shortboard="7316,1000,9999",fish="2288,1000,9999",gun="5907,1000,9999",twin="1234,1000,9999"}'
if [[ -z "$(tm_state_attr 'random_integer.ticket["longboard"]' result)" ]]; then
  tm_plan_json
  N=$(jq '[.resource_changes[]? | select(.change.importing != null)] | length' "$TM_TMP/plan.json")
  [[ "$N" == "4" ]] || tm_fail "the plan imports $N tickets, expected 4"
fi
tm_plan_json -var "$EXTRA"
HAS_TWIN=$(jq -r '[.resource_changes[]? | select(.address=="random_integer.ticket[\"twin\"]") | .change.importing != null] | any' "$TM_TMP/plan.json")
[[ "$HAS_TWIN" == "true" ]] || tm_fail "adding a ticket to var.legacy_tickets does not produce an import for it: the import blocks are not driven by the variable"

tm_apply

for pair in longboard=4021 shortboard=7316 fish=2288 gun=5907; do
  job=${pair%%=*}; num=${pair##*=}
  tm_assert_in_state "random_integer.ticket[\"$job\"]"
  [[ "$(tm_state_attr "random_integer.ticket[\"$job\"]" result)" == "$num" ]] || tm_fail "ticket '$job' is not number $num: it was generated, not adopted"
done
[[ "$(tm_state_attr random_pet.shaper id)" == "$SHAPER" ]] || tm_fail "the shaper codename changed"

tm_assert_file_equals shop/queue.txt "on shift: ${SHAPER}"$'\n'"fish: #2288"$'\n'"gun: #5907"$'\n'"longboard: #4021"$'\n'"shortboard: #7316"$'\n'
tm_assert_no_changes
tm_pass "all four paper tickets were adopted in one for_each import"
