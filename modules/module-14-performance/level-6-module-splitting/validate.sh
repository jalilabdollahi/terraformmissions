#!/usr/bin/env bash
source "$TM_LIB"

BATCH=$(tm_recall batch); LABEL=$(tm_recall label)
[[ -n "$BATCH" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

for m in pour colour label; do
  [[ -d modules/$m ]] || tm_fail "modules/$m does not exist"
  grep -qE '^[[:space:]]*resource[[:space:]]' modules/$m/*.tf 2>/dev/null \
    || tm_fail "modules/$m declares no resources"
  tm_assert_config_has "module[[:space:]]+\"$m\"" "the root must call module \"$m\""
done
tm_assert_config_lacks 'module[[:space:]]+"workshop"' "the root must not call the old workshop module"
if grep -qE '^[[:space:]]*resource[[:space:]]' modules/workshop/*.tf 2>/dev/null; then
  tm_fail "modules/workshop still declares resources — it should be gone"
fi
if grep -qE '^[[:space:]]*module[[:space:]]' modules/*/*.tf 2>/dev/null; then
  tm_fail "the small modules should stay independent (no module calls inside modules/*)"
fi
tm_assert_config_has 'module\.pour\.' "the label module must be fed from module.pour outputs"
tm_assert_config_has 'module\.colour\.' "the label module must be fed from module.colour outputs"

grep -qE 'resource[[:space:]]+"random_id"' modules/pour/*.tf || tm_fail "random_id.batch belongs in modules/pour"
grep -qE '"pour_sheet"' modules/pour/*.tf || tm_fail "local_file.pour_sheet belongs in modules/pour"
grep -qE '"colour_spec"' modules/colour/*.tf || tm_fail "local_file.colour_spec belongs in modules/colour"
grep -qE '"label"' modules/label/*.tf || tm_fail "local_file.label belongs in modules/label"

tm_init
tm_validate

# A refactor must plan as moves only. Check the plan first, then apply it (moved blocks take effect on apply).
TM_MSG="the plan would destroy or replace existing objects" tm_assert_no_destroy
tm_apply

tm_assert_in_state module.pour.random_id.batch "random_id.batch must live at module.pour.random_id.batch"
tm_assert_in_state module.pour.local_file.pour_sheet "module.pour.local_file.pour_sheet is not in state"
tm_assert_in_state module.colour.local_file.colour_spec "module.colour.local_file.colour_spec is not in state"
tm_assert_in_state module.label.local_file.label "module.label.local_file.label is not in state"
all_state=$(tm_state_list)
if grep -q '^module\.workshop' <<<"$all_state"; then
  tm_fail "state still has objects under module.workshop"
fi
[[ "$(tm_state_attr module.pour.random_id.batch hex)" == "$BATCH" ]] \
  || tm_fail "the batch ID changed — the printed boxes would no longer match"

tm_assert_no_changes
[[ "$(cat out/label.txt)" == "$LABEL" ]] || tm_fail "out/label.txt changed"
tm_assert_output label_text "$LABEL"
tm_pass "three composable modules, batch $BATCH preserved, nothing destroyed"
