#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'source[[:space:]]*=[[:space:]]*"\./modules/folds"' \
  "the call must keep using the local module at ./modules/folds"

# no module-level version constraint may remain in the call
if awk '/^module[[:space:]]/{m=1} m && /^[[:space:]]*version[[:space:]]*=/{f=1} /^}/{m=0} END{exit f?0:1}' main.tf 2>/dev/null; then
  tm_fail "the module block still carries a version argument"
fi

tm_init "terraform init failed — read what it says about the module block"
TM_MSG="terraform apply failed" tm_apply

tm_assert_in_state module.pattern.local_file.sheet "the sheet must be produced inside module.pattern"
tm_assert_output steps 6
tm_assert_output sheet "./models/crane.txt"
tm_assert_file_contains models/crane.txt "6. Shape the head"

tm_apply -var model=frog
tm_assert_output steps 4
tm_assert_file_contains models/frog.txt "4. Press the back to jump"

tm_apply
tm_assert_no_changes
tm_pass "the local module works without a version argument for both models"
