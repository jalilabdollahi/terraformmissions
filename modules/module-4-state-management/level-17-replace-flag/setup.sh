#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
for e in stage pit box-office booth; do
  tm_record "code_$e" "$(tm_state_attr "random_integer.door_code[\"$e\"]" result)"
done
