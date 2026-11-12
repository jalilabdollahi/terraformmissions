#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'provider[[:space:]]*=[[:space:]]*random\.north_pit' "random_id.north_tag must use the north_pit configuration"
tm_assert_config_has 'provider[[:space:]]*=[[:space:]]*random\.south_pit' "random_id.south_tag must use the south_pit configuration"
tm_assert_config_lacks 'provider[[:space:]]*=[[:space:]]*"' "provider references must be written as bare references, not quoted strings"

tm_validate "the configuration does not validate"
tm_apply

# Which provider configuration does each object in state belong to?
PROV=$(terraform state pull 2>/dev/null | jq -r '.resources[] | select(.type=="random_id") | "\(.name)=\(.provider)"')
grep -qF 'north_tag=provider["registry.terraform.io/hashicorp/random"].north_pit' <<<"$PROV" \
  || tm_fail "random_id.north_tag is not managed through the north_pit configuration"
grep -qF 'south_tag=provider["registry.terraform.io/hashicorp/random"].south_pit' <<<"$PROV" \
  || tm_fail "random_id.south_tag is not managed through the south_pit configuration"

N=$(tm_output_raw north_tag); S=$(tm_output_raw south_tag)
[[ ${#N} -eq 6 && ${#S} -eq 6 ]] || tm_fail "both tags should be 6 hex characters"
tm_assert_file_equals dig/specimens.txt "north pit tag: ${N}"$'\n'"south pit tag: ${S}"$'\n'
tm_assert_no_changes
tm_pass "both tags are issued through their own pit's provider configuration"
