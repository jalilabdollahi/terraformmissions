#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'count[[:space:]]*=' "module.post has to be created with count"

tm_init
TM_MSG="terraform apply failed — look at which expression Terraform says cannot be evaluated" tm_apply

for i in 0 1 2; do
  tm_assert_in_state "module.post[$i].terraform_data.lamp" "module.post[$i] is missing — one instance per post is expected"
done
tm_assert_not_in_state "module.post[3].terraform_data.lamp" "too many posts were created"
tm_assert_output_jq labels '. == ["LP-01","LP-02","LP-03"]' "labels must be the numbered list LP-01..LP-03"
tm_assert_output last_label "LP-03"

tm_apply -var posts_total=5
tm_assert_output_jq labels '. == ["LP-01","LP-02","LP-03","LP-04","LP-05"]' "labels must follow posts_total"
tm_assert_output last_label "LP-05"

tm_apply -var posts_total=2
tm_assert_output_jq labels '. == ["LP-01","LP-02"]'
tm_assert_output last_label "LP-02"

tm_apply
tm_assert_no_changes
tm_pass "module.post[*] is numbered 1..n and the outputs follow the instance count"
