#!/usr/bin/env bash
source "$TM_LIB"

SERIAL=$(tm_recall serial); INTERVAL=$(tm_recall interval)
[[ -n "$SERIAL" && -n "$INTERVAL" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'path[[:space:]]*=[[:space:]]*"vault/buoys-prod.tfstate"' \
  "the backend path in terraform.tf must stay vault/buoys-prod.tfstate"

[[ -f .terraform/terraform.tfstate ]] || tm_fail "the backend has not been initialised"
INIT_PATH=$(jq -r '.backend.config.path // empty' .terraform/terraform.tfstate)
[[ "$INIT_PATH" == "vault/buoys-prod.tfstate" ]] \
  || tm_fail "Terraform is still initialised against '$INIT_PATH' — the backend change has not been processed yet"

tm_assert_file vault/buoys-prod.tfstate "vault/buoys-prod.tfstate does not exist"
tm_assert_in_state random_id.buoy_serial "the buoy serial is not in the new state — the old state was not carried over"
[[ "$(tm_state_attr random_id.buoy_serial hex)" == "$SERIAL" ]] || tm_fail "the buoy serial changed — resources were recreated instead of migrated"
[[ "$(tm_state_attr random_integer.sampling_interval result)" == "$INTERVAL" ]] || tm_fail "the sampling interval changed"

tm_assert_no_changes
tm_assert_file_contains config/buoy.conf "serial=$SERIAL" "config/buoy.conf lost the original serial"
tm_pass "state now lives in vault/buoys-prod.tfstate with buoy $SERIAL intact"
