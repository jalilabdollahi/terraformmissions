#!/usr/bin/env bash
source "$TM_LIB"

tm_validate
tm_assert_config_lacks 'separator[[:space:]]*=[[:space:]]*"[^"]' "do not hard-code a separator; leave it to the provider default when the variable is unset"
tm_assert_config_has 'var\.slug_separator' "the separator must still be driven by var.slug_separator"

tm_apply
s=$(tm_output_raw slug) || tm_fail "output slug is missing"
[[ "$s" =~ ^ep-[a-z]+-[a-z]+$ ]] || tm_fail "with no override the slug is '$s' — expected ep-<word>-<word> (default separator)"
tm_assert_file_equals podcast/slug.txt "Next episode slug: ${s}"$'\n'

tm_apply -var 'slug_separator=_'
s2=$(tm_output_raw slug) || tm_fail "output slug is missing"
[[ "$s2" =~ ^ep_[a-z]+_[a-z]+$ ]] || tm_fail "with slug_separator=_ the slug is '$s2' — expected ep_<word>_<word>"

tm_apply
tm_assert_no_changes
tm_pass "unset separator falls back to the default; an override still works"
