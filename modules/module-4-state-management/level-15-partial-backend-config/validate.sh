#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'backend[[:space:]]+"local"' "the local backend block was removed from terraform.tf"
tm_assert_config_lacks 'path[[:space:]]*=' "the state path is hard-coded in a .tf file — it must come from the backend config file"
tm_assert_config_has 'resource "random_pet" "callsign"' "the callsign resource was removed from the configuration"
tm_assert_file config/backend-prod.hcl "config/backend-prod.hcl is missing"

[[ -f .terraform/terraform.tfstate ]] || tm_fail "the backend has not been initialised"
INIT_PATH=$(jq -r '.backend.config.path // empty' .terraform/terraform.tfstate)
[[ -n "$INIT_PATH" ]] || tm_fail "the backend is initialised with the default location — the backend config file was not applied"
[[ "$INIT_PATH" == "state/signal-tower.tfstate" ]] \
  || tm_fail "the backend is initialised with path '$INIT_PATH', expected state/signal-tower.tfstate"

tm_apply
tm_assert_file state/signal-tower.tfstate "state/signal-tower.tfstate was not written"
COUNT=$(jq '.resources | length' state/signal-tower.tfstate 2>/dev/null)
[[ "${COUNT:-0}" -ge 3 ]] || tm_fail "state/signal-tower.tfstate does not hold the tower's three resources yet"
tm_assert_no_changes
tm_assert_file_contains beacon/signal.txt "broadcasting on" "the beacon file was not written"
tm_pass "the tower's state lives in state/signal-tower.tfstate, supplied through -backend-config"
