#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'for_each[[:space:]]*=[[:space:]]*var\.sections' "module.section has to stay a for_each module over var.sections"

tm_init
TM_MSG="terraform apply failed — what is the type of module.section when for_each is used?" tm_apply

for v in soprano alto tenor bass; do
  tm_assert_in_state "module.section[\"$v\"].terraform_data.slot"
done
tm_assert_output_jq rehearsal_minutes '. == {"soprano":60,"alto":45,"tenor":30,"bass":35}' "rehearsal_minutes must map each voice to its minutes"
tm_assert_output total_minutes 170

tm_apply -var 'sections={bass=3,alto=4}'
tm_assert_output_jq rehearsal_minutes '. == {"bass":15,"alto":20}'
tm_assert_output total_minutes 35

tm_apply
tm_assert_no_changes
tm_pass "the for_each instances are collected into a map by voice and summed"
