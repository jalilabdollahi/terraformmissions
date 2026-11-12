#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'module[[:space:]]+"berths"' "the berths module must stay"
tm_assert_config_has 'module[[:space:]]+"galley"' "the galley module must stay"
tm_assert_config_has 'random_integer' "the galley module must still draw the supply batch"
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

CABIN=$(tm_output_raw cabin_label)
SUPPLY=$(tm_output_raw supply_batch)
[[ "$CABIN" == willow-wren-cabin-* ]] || tm_fail "cabin_label looks wrong: '$CABIN'"
[[ "$SUPPLY" =~ ^[0-9]{3}$ ]] || tm_fail "supply_batch should be a three digit number: '$SUPPLY'"
tm_assert_file_equals boat/booking.txt "Cabin $CABIN | galley batch $SUPPLY"$'\n' "boat/booking.txt does not match the module outputs"
tm_pass "one random provider ($LOCKED) now satisfies the root and both modules"
