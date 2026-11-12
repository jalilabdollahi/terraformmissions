#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'configuration_aliases' "the child module has to declare which extra provider configurations it expects"
tm_assert_config_has 'random\.spare[[:space:]]*=[[:space:]]*random\.back_bench' "the root must hand its back_bench configuration to the module's spare slot"

# validate must be completely quiet: no errors and no 'undefined provider' warnings
if ! tm_tf validate; then tm_show_last; tm_fail "terraform validate fails"; fi
grep -qi 'warning' "$TM_LAST_OUT" && { tm_show_last; tm_fail "terraform validate still prints warnings about the module's providers"; }

tm_apply

PROV=$(terraform state pull 2>/dev/null | jq -r '.resources[] | select(.type=="random_id") | "\(.name)=\(.provider)"')
grep -qF 'spare_reel=provider["registry.terraform.io/hashicorp/random"].back_bench' <<<"$PROV" \
  || tm_fail "module.ribbons.random_id.spare_reel is not running on the root's back_bench configuration"
grep -qF 'primary_reel=provider["registry.terraform.io/hashicorp/random"]' <<<"$PROV" || tm_fail "primary reel missing"
grep -F 'primary_reel=' <<<"$PROV" | grep -q 'back_bench' && tm_fail "the primary reel must stay on the default configuration"

tm_assert_in_state module.ribbons.random_id.primary_reel
tm_assert_in_state module.ribbons.random_id.spare_reel
P=$(tm_output_raw primary_reel); S=$(tm_output_raw spare_reel)
[[ ${#P} -eq 4 && ${#S} -eq 4 && "$P" != "$S" ]] || tm_fail "outputs should be two different 4-character reel numbers"
tm_assert_no_changes
tm_pass "the module's spare reel runs on the back_bench provider configuration"
