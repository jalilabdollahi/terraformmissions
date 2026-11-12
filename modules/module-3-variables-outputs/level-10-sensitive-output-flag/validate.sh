#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_lacks 'nonsensitive[[:space:]]*\(' "nonsensitive() strips the protection — the URL does contain a secret"
[[ $(grep -rhE 'sensitive[[:space:]]*=[[:space:]]*true' --include='*.tf' . | wc -l | tr -d ' ') -ge 2 ]] \
  || tm_fail "the password variable must stay sensitive AND the derived output must be marked sensitive"

tm_apply
SECRET="atrium-Marble-92"
if grep -qF "$SECRET" "$TM_LAST_OUT"; then
  tm_fail "the password leaked into the apply output"
fi
sens=$(terraform output -json 2>/dev/null | jq -r '.portal_login_url.sensitive // false')
[[ "$sens" == "true" ]] || tm_fail "output portal_login_url is not marked sensitive"
url=$(terraform output -json portal_login_url | jq -r '.')
[[ "$url" == "https://concierge:${SECRET}@portal.granite-gate.example/admin" ]] \
  || tm_fail "portal_login_url must still contain the real URL, found: '$url'"
plain=$(terraform output 2>/dev/null)
grep -qF -- "$SECRET" <<<"$plain" \
  && tm_fail "plain 'terraform output' prints the secret — it should be redacted"
tm_assert_output mall "Granite Gate Mall"
tm_pass "portal_login_url is marked sensitive: redacted in the CLI, still usable through -json"
