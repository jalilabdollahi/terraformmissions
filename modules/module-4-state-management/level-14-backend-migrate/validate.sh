#!/usr/bin/env bash
source "$TM_LIB"

SERIAL=$(tm_recall serial); INTERVAL=$(tm_recall interval)
[[ -n "$SERIAL" && -n "$INTERVAL" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'path[[:space:]]*=[[:space:]]*"vault/kiosks-prod.tfstate"' \
  "the backend path in terraform.tf must stay vault/kiosks-prod.tfstate"

[[ -f .terraform/terraform.tfstate ]] || tm_fail "the backend has not been initialised"
INIT_PATH=$(jq -r '.backend.config.path // empty' .terraform/terraform.tfstate)
[[ "$INIT_PATH" == "vault/kiosks-prod.tfstate" ]] \
  || tm_fail "Terraform is still initialised against '$INIT_PATH' — the backend change has not been processed yet"

tm_assert_file vault/kiosks-prod.tfstate "vault/kiosks-prod.tfstate does not exist"
tm_assert_in_state random_id.kiosk_serial "the kiosk serial is not in the new state — the old state was not carried over"
[[ "$(tm_state_attr random_id.kiosk_serial hex)" == "$SERIAL" ]] || tm_fail "the kiosk serial changed — resources were recreated instead of migrated"
[[ "$(tm_state_attr random_integer.refresh_interval result)" == "$INTERVAL" ]] || tm_fail "the refresh interval changed"

tm_assert_no_changes
tm_assert_file_contains config/kiosk.conf "serial=$SERIAL" "config/kiosk.conf lost the original serial"
tm_pass "state now lives in vault/kiosks-prod.tfstate with kiosk $SERIAL intact"
