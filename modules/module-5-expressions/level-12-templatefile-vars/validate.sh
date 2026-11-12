#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'templatefile[[:space:]]*\(' "the form must be rendered with templatefile()"
[[ -f telegram.tpl ]] || tm_fail "telegram.tpl is missing — the form must stay a template file"

tm_apply
WANT='STATION: DUNMORE
TO: Capt. Hale, Harbour Master
FROM: Office of the Postmaster
WORDS: 8
---
Packet boat delayed by fog arrives Thursday noon
'
tm_assert_file_equals outbox/telegram.txt "$WANT"
[[ "$(tm_output_raw telegram; echo x)" == "${WANT}x" ]] || tm_fail "output 'telegram' does not match the rendered form"

# The form must be driven by the variables.
tm_plan_json -var station=kilbrae -var 'recipient=Dr. Orme' -var 'sender=Lamp Room' -var 'body=Send two spare mantles'
got=$(jq -r '.planned_values.outputs.telegram.value' "$TM_TMP/plan.json")
want=$'STATION: KILBRAE\nTO: Dr. Orme\nFROM: Lamp Room\nWORDS: 4\n---\nSend two spare mantles\n'
[[ "$got" == "${want%$'\n'}" ]] || { echo "$got" | sed 's/^/   │ /'; tm_fail "a second telegram must be rendered from the variables (STATION KILBRAE, TO Dr. Orme, FROM Lamp Room, 4 words)"; }
tm_pass "the telegram template is fed exactly the variables its placeholders use"
