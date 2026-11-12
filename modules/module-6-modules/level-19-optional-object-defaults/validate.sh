#!/usr/bin/env bash
source "$TM_LIB"

tm_init
TM_MSG="terraform apply failed — which attribute does the error say is required?" tm_apply

tm_assert_in_state local_file.lineup
tm_assert_file_equals radio/lineup.txt $'kids stories@128k\nlate_show jazz@128k +jingle\nmorning talk@64k +jingle\n'

# The defaults must apply to other callers' maps too
cat >"$TM_TMP/other.tfvars.json" <<'JSON'
{"streams": {"night": {"genre": "ambient", "jingle": false}, "dawn": {"genre": "news", "bitrate_kbps": 96}}}
JSON
tm_apply -var-file="$TM_TMP/other.tfvars.json"
tm_assert_file_equals radio/lineup.txt $'dawn news@96k +jingle\nnight ambient@128k\n'

# genre has no default: leaving it out must still be rejected
cat >"$TM_TMP/bad.tfvars.json" <<'JSON'
{"streams": {"bad": {"bitrate_kbps": 64}}}
JSON
code=$(tm_plan_code -var-file="$TM_TMP/bad.tfvars.json")
[[ "$code" == "1" ]] || tm_fail "a stream without a genre was accepted — genre must stay required"

tm_apply
tm_assert_no_changes
tm_assert_config_has 'optional\(' "the module's object type should mark the optional attributes with optional()"
tm_assert_config_has 'genre[[:space:]]*=[[:space:]]*string' "genre has to stay a required string attribute"
tm_assert_config_lacks 'default[[:space:]]*=[[:space:]]*\{[[:space:]]*\}' "don't give the module's streams variable an empty default"
tm_pass "optional() fills bitrate and jingle; genre is still required"
