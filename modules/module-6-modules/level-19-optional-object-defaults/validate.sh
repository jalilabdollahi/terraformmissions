#!/usr/bin/env bash
source "$TM_LIB"

tm_init
TM_MSG="terraform apply failed — which attribute does the error say is required?" tm_apply

tm_assert_in_state local_file.rota
tm_assert_file_equals queues/rota.txt $'billing refunds@128k\nnight_desk triage@128k +jingle\nsales_line upgrades@64k +jingle\n'

# The defaults must apply to other callers' maps too
cat >"$TM_TMP/other.tfvars.json" <<'JSON'
{"queues": {"overnight": {"skill": "escalations", "jingle": false}, "early": {"skill": "claims", "bitrate_kbps": 96}}}
JSON
tm_apply -var-file="$TM_TMP/other.tfvars.json"
tm_assert_file_equals queues/rota.txt $'early claims@96k +jingle\novernight escalations@128k\n'

# skill has no default: leaving it out must still be rejected
cat >"$TM_TMP/bad.tfvars.json" <<'JSON'
{"queues": {"bad": {"bitrate_kbps": 64}}}
JSON
code=$(tm_plan_code -var-file="$TM_TMP/bad.tfvars.json")
[[ "$code" == "1" ]] || tm_fail "a queue without a skill was accepted — skill must stay required"

tm_apply
tm_assert_no_changes
tm_assert_config_has 'optional\(' "the module's object type should mark the optional attributes with optional()"
tm_assert_config_has 'skill[[:space:]]*=[[:space:]]*string' "skill has to stay a required string attribute"
tm_assert_config_lacks 'default[[:space:]]*=[[:space:]]*\{[[:space:]]*\}' "don't give the module's queues variable an empty default"
tm_pass "optional() fills bitrate and jingle; skill is still required"
