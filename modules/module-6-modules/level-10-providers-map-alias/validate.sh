#!/usr/bin/env bash
source "$TM_LIB"

tm_init "terraform init failed — read what it says about provider configurations for module.ledger"
TM_MSG="terraform apply failed — which provider configuration is the ledger module missing?" tm_apply

tm_assert_in_state module.ledger.local_file.primary
tm_assert_in_state module.ledger.local_file.mirror
tm_assert_file_equals ledger/primary.txt $'Varnish removal, oil portrait 1887\n'
tm_assert_file_equals ledger/mirror.txt $'Varnish removal, oil portrait 1887\n'

# The alias is visible in state: each resource records which provider configuration manages it
providers_of() {
  terraform state pull 2>/dev/null | jq -r --arg n "$1" \
    '.resources[] | select(.module=="module.ledger" and .name==$n) | .provider'
}
mirror_provider=$(providers_of mirror)
primary_provider=$(providers_of primary)
[[ "$mirror_provider" == *'.offsite' ]] \
  || tm_fail "the mirror copy is managed by '$mirror_provider', not by the aliased offsite configuration"
[[ "$primary_provider" != *'.offsite' ]] \
  || tm_fail "the primary copy must use the default local provider, not the offsite alias"

tm_assert_config_has 'configuration_aliases' "the ledger module must keep declaring the alias it needs"
tm_assert_config_has 'providers[[:space:]]*=[[:space:]]*\{' "module.ledger needs an explicit providers map"
tm_assert_config_has 'alias[[:space:]]*=[[:space:]]*"offsite"' "the root must keep its aliased offsite provider"

tm_assert_no_changes
tm_pass "module.ledger writes its primary copy with local and its mirror with local.offsite"
