#!/usr/bin/env bash
source "$TM_LIB"
export TF_VAR_seal_tokens='{"petra":"demo-not-a-real-secret-petra-11","merv":"demo-not-a-real-secret-merv-22","palmyra":"demo-not-a-real-secret-palmyra-33"}'

tm_assert_config_lacks 'nonsensitive[[:space:]]*\(' "nonsensitive() is not the way out of this one — separate what is secret from what is not"
tm_assert_config_has 'variable[[:space:]]+"post_names"' "declare a plain (non-secret) variable post_names"
tm_assert_config_has 'variable[[:space:]]+"seal_tokens"' "declare the sensitive variable seal_tokens"
tm_validate "the configuration does not validate"

tm_apply
for post in petra merv palmyra; do
  f="seals/$post.seal"
  tm_assert_file "$f" "the seal file for $post was not written ($f)"
  want="demo-not-a-real-secret-$post-"
  grep -qF -- "$want" "$f" || tm_fail "$f does not hold the token for $post"
  [[ "$(tm_file_mode "$f")" == "600" ]] || tm_fail "$f must keep mode 0600"
done

tm_assert_output post_count 3
J=$(terraform output -json 2>/dev/null)
[[ "$(jq -r '.seal_digests.sensitive' <<<"$J")" == "true" ]] \
  || tm_fail "seal_digests is derived from secret tokens, so it must stay a sensitive output"
WANT=$(printf '%s' "demo-not-a-real-secret-merv-22" | python3 -c 'import hashlib,sys; print(hashlib.sha256(sys.stdin.buffer.read()).hexdigest())')
[[ "$(jq -r '.seal_digests.value.merv' <<<"$J")" == "$WANT" ]] || tm_fail "seal_digests.merv is not the sha256 of merv's token"

SHOWN=$(terraform output 2>&1)
[[ "$SHOWN" != *"$WANT"* && "$SHOWN" == *"seal_digests = <sensitive>"* ]] || tm_fail "'terraform output' must show seal_digests as <sensitive>"

tm_plan_code >/dev/null
if grep -q 'demo-not-a-real-secret' "$TM_LAST_OUT"; then tm_fail "a seal token shows up in terraform plan output"; fi
tm_assert_no_changes
tm_pass "post names drive for_each, tokens stay sensitive, digests are redacted"
