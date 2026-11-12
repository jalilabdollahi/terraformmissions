#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
for e in main vip cloakroom dj; do
  tm_record "code_$e" "$(tm_state_attr "random_integer.door_code[\"$e\"]" result)"
done
