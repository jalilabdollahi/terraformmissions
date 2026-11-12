#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'validation[[:space:]]*\{' "the policy must be enforced with validation blocks"
tm_validate "the configuration does not validate"

# must be refused BY VARIABLE VALIDATION, not by some other error
refuse() {
  local label="$1"; shift
  terraform plan -input=false -no-color "$@" >"$TM_LAST_OUT" 2>&1 </dev/null
  local code=$?
  if [[ $code -eq 0 || $code -eq 2 ]]; then
    tm_fail "policy hole: $label was accepted"
  fi
  grep -q 'Invalid value for variable' "$TM_LAST_OUT" || { tm_show_last; tm_fail "$label failed, but not through a variable validation rule"; }
}
accept() {
  local label="$1"; shift
  local code
  code=$(tm_plan_code "$@")
  if [[ "$code" != "0" && "$code" != "2" ]]; then tm_show_last; tm_fail "the policy is too strict: $label was rejected"; fi
}

refuse "0.0.0.0/0 next to a good network" -var 'allowed_cidrs=["10.30.0.0/16","0.0.0.0/0"]'
refuse "the IPv6 world ::/0"               -var 'allowed_cidrs=["::/0"]'
refuse "a /1 network"                      -var 'allowed_cidrs=["10.30.0.0/16","0.0.0.0/1"]'
refuse "an empty network list"             -var 'allowed_cidrs=[]'
refuse "something that is not a network"   -var 'allowed_cidrs=["office-wifi"]'
refuse "TLS 1.0"                           -var 'min_tls_version=1.0'
refuse "TLS 1.1"                           -var 'min_tls_version=1.1'
refuse "a made-up TLS version"             -var 'min_tls_version=9.9'

accept "the default settings"
accept "TLS 1.3 with an IPv6 ULA network"  -var 'min_tls_version=1.3' -var 'allowed_cidrs=["fd00:30::/32","10.30.0.0/16"]'

tm_apply
tm_assert_file_contains gateway/archive-vpn.conf "tls_min_version = 1.2"
tm_assert_file_contains gateway/archive-vpn.conf "allow 192.168.40.0/24"
tm_assert_output allowed_count 2
tm_assert_no_changes
tm_pass "the security policy is enforced by variable validation and accepts legitimate input"
