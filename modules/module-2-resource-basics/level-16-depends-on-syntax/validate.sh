#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'depends_on[[:space:]]*=[[:space:]]*\[local_file\.clues\]' "terraform_data.clue_counter / local_file.title must declare depends_on = [local_file.clues]"
tm_assert_config_lacks 'depends_on[[:space:]]*=[[:space:]]*\[[[:space:]]*"' "depends_on entries must be references, not quoted strings"
tm_assert_config_lacks 'depends_on[[:space:]]*=[[:space:]]*\[[^]]*local_file\.clues\.[a-z_]+' "depends_on takes whole resources, not attributes"
tm_assert_config_has 'resource "terraform_data" "clue_counter"' "terraform_data.clue_counter must stay"
tm_assert_config_has 'provisioner "local-exec"' "the counter must remain a local-exec step"
tm_apply
tm_assert_file_equals puzzle/clue-count.txt "5
"
tm_assert_file puzzle/title.txt
# the recorded dependencies in state prove the ordering edge exists
for R in terraform_data.clue_counter local_file.title; do
  T=${R%%.*}; N=${R#*.}
  terraform state pull 2>/dev/null | jq -e --arg t "$T" --arg n "$N" \
    '[.resources[] | select(.type==$t and .name==$n) | .instances[0].dependencies[]?] | index("local_file.clues")' >/dev/null \
    || tm_fail "$R does not record a dependency on local_file.clues"
done
tm_assert_no_changes
tm_pass "both depends_on declarations are valid and the counter ran after clues.txt"
