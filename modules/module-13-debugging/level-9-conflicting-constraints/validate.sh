#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'module[[:space:]]+"bunks"' "the bunks module must stay"
tm_assert_config_has 'module[[:space:]]+"meals"' "the meals module must stay"
tm_assert_config_has 'random_integer' "the meals module must still draw the soup batch"
tm_assert_config_lacks '~>[[:space:]]*2\.3' "a constraint that only allows random 2.x can never agree with the root module"

[[ -f .terraform.lock.hcl ]] || tm_fail "terraform init has not produced a lock file - the constraints are still unsatisfiable"
LOCKED=$(awk '/provider "registry.terraform.io\/hashicorp\/random"/{f=1} f && /^[[:space:]]*version/{gsub(/[" ]/,"",$3); print $3; exit}' .terraform.lock.hcl)
MAJOR=${LOCKED%%.*}
REST=${LOCKED#*.}
MINOR=${REST%%.*}
[[ "$MAJOR" == "3" && "$MINOR" -ge 6 ]] \
  || tm_fail "the random provider is locked at '$LOCKED' - the root module requires 3.6 or newer"

tm_apply
tm_assert_no_changes
tm_assert_no_changes

ROOM=$(tm_output_raw room_label)
SOUP=$(tm_output_raw soup_batch)
[[ "$ROOM" == alpenrose-room-* ]] || tm_fail "room_label looks wrong: '$ROOM'"
[[ "$SOUP" =~ ^[0-9]{3}$ ]] || tm_fail "soup_batch should be a three digit number: '$SOUP'"
tm_assert_file_equals hut/booking.txt "Bunk room $ROOM | soup batch $SOUP"$'\n' "hut/booking.txt does not match the module outputs"
tm_pass "one random provider ($LOCKED) now satisfies the root and both modules"
