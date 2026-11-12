#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'for_each[[:space:]]*=' "module.piece has to be created with for_each"
tm_assert_config_lacks 'count[[:space:]]*=' "use for_each (keys by name), not count"

tm_init
TM_MSG="terraform apply failed — first the for_each argument, then the key used in the output" tm_apply

for k in bowl ornament vase; do
  tm_assert_in_state "module.piece[\"$k\"].terraform_data.anneal" "module.piece[\"$k\"] is not in state"
done
tm_assert_output vase_hours 10
tm_assert_file_equals kiln/schedule.txt $'bowl:6h\nornament:4h\nvase:10h\n'

# a different catalogue: the instances must follow the list
tm_apply -var 'pieces=["vase","paperweight"]'
tm_assert_in_state 'module.piece["paperweight"].terraform_data.anneal' "paperweight instance missing"
tm_assert_not_in_state 'module.piece["bowl"].terraform_data.anneal' "bowl should have been removed"
tm_assert_file_equals kiln/schedule.txt $'paperweight:14h\nvase:10h\n'

tm_apply
tm_assert_no_changes
tm_pass "one module.piece instance per ware, addressed by name"
