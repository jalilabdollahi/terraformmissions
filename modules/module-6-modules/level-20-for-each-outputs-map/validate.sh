#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'for_each[[:space:]]*=[[:space:]]*var\.classes' "module.classroom has to stay a for_each module over var.classes"

tm_init
TM_MSG="terraform apply failed — what is the type of module.classroom when for_each is used?" tm_apply

for v in vinyasa hatha yin ashtanga; do
  tm_assert_in_state "module.classroom[\"$v\"].terraform_data.slot"
done
tm_assert_output_jq prep_minutes '. == {"vinyasa":60,"hatha":45,"yin":30,"ashtanga":35}' "prep_minutes must map each style to its minutes"
tm_assert_output total_minutes 170

tm_apply -var 'classes={ashtanga=3,hatha=4}'
tm_assert_output_jq prep_minutes '. == {"ashtanga":15,"hatha":20}'
tm_assert_output total_minutes 35

tm_apply
tm_assert_no_changes
tm_pass "the for_each instances are collected into a map by style and summed"
