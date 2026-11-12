#!/usr/bin/env bash
source "$TM_LIB"

NT=$(tm_recall north_tag); NF=$(tm_recall north_file); ST=$(tm_recall south_tag)
[[ -n "$NT" && -n "$NF" && -n "$ST" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'module[[:space:]]+"north_shaft"' "the module call must keep its new name north_shaft"
tm_assert_config_has 'from[[:space:]]*=[[:space:]]*module\.shaft_a[[:space:]]*$' \
  "record the rename of the whole module call (from = module.shaft_a) in a moved block"
tm_assert_config_has 'to[[:space:]]*=[[:space:]]*module\.north_shaft[[:space:]]*$' "the moved block must end at module.north_shaft"

TM_MSG="the plan would destroy objects whose only change is the name of their module call" tm_assert_no_destroy
tm_apply

tm_assert_in_state module.north_shaft.random_id.tag
tm_assert_in_state module.north_shaft.local_file.placard
for old in module.shaft_a.random_id.tag module.shaft_a.local_file.placard; do
  tm_assert_not_in_state "$old" "$old is still in state"
done

[[ "$(tm_state_attr module.north_shaft.random_id.tag hex)" == "$NT" ]] || tm_fail "the north shaft's inspection tag changed"
[[ "$(tm_state_attr module.north_shaft.local_file.placard id)" == "$NF" ]] || tm_fail "the north placard was recreated"
[[ "$(tm_state_attr module.south_shaft.random_id.tag hex)" == "$ST" ]] || tm_fail "the south shaft was touched"
tm_assert_output north_tag "$NT"
tm_assert_file_contains placards/north.txt "inspection tag ${NT}"
tm_assert_no_changes
tm_pass "module.shaft_a became module.north_shaft with every object preserved"
