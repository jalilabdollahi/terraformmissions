#!/usr/bin/env bash
source "$TM_LIB"
LEAKED="demo-not-a-real-secret-brass-5521"
FRESH="demo-not-a-real-secret-brass-9090"

tm_assert_config_lacks 'demo-not-a-real-secret-brass' "the committed gateway key is still sitting in a .tf / .tfvars file"
tm_assert_config_lacks 'gateway_api_key[[:space:]]*=' "gateway_api_key is still assigned in a tfvars file or default"
tm_assert_config_has 'band_name[[:space:]]*=' "the harmless settings (band_name, ticket_price_pence) should stay in terraform.tfvars"

# without the environment variable the key must be demanded, not silently found in a file
env -u TF_VAR_gateway_api_key terraform plan -input=false -no-color >"$TM_LAST_OUT" 2>&1 </dev/null
[[ $? -ne 0 ]] || tm_fail "terraform planned without any gateway key — the key must be supplied from outside the repo"

export TF_VAR_gateway_api_key="$FRESH"
tm_apply
tm_assert_file_contains box-office/gateway.env "GATEWAY_KEY=$FRESH" "the gateway credentials file does not hold the key from TF_VAR_gateway_api_key"
[[ "$(tm_file_mode box-office/gateway.env)" == "600" ]] || tm_fail "box-office/gateway.env must stay mode 0600"
tm_assert_file_contains box-office/ticket-desk.txt "Harbourside Brass - ticket price: 12.50 GBP" "the ticket desk file lost its tfvars-driven values"
if grep -qF -- "$FRESH" "$TM_LAST_OUT"; then tm_fail "the key was printed by apply"; fi
tm_assert_no_changes
tm_pass "the key now arrives through TF_VAR_gateway_api_key and no file in the repo contains it"
