#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has '%\{[[:space:]]*for ' "the berth list must be produced by a %{ for } directive in the template"
tm_assert_config_has '%\{[[:space:]]*if ' "the breakfast note and the empty-train message need %{ if } directives"

tm_apply
tm_assert_file_equals manifests/sleeper.txt "Nightjar Express to Inverness
Berths:
  A1  Mrs Dunlop (breakfast)
  A2  Mr Ito
  B4  Dr Okonkwo (breakfast)
Total: 3
"

tm_plan_json -var destination=Oban -var 'passengers=[{berth="C2",name="Ms Vane",breakfast=false}]'
got=$(jq -j '.planned_values.outputs.manifest.value' "$TM_TMP/plan.json"; echo x); got=${got%x}
want='Nightjar Express to Oban
Berths:
  C2  Ms Vane
Total: 1
'
[[ "$got" == "$want" ]] || { printf '%s' "$got" | sed 's/^/   │ /'; tm_fail "a one-passenger train to Oban should render exactly: header, Berths:, '  C2  Ms Vane', Total: 1 — no blank lines"; }

tm_plan_json -var 'passengers=[]'
got=$(jq -j '.planned_values.outputs.manifest.value' "$TM_TMP/plan.json"; echo x); got=${got%x}
want='Nightjar Express to Inverness
Berths:
No passengers tonight.
'
[[ "$got" == "$want" ]] || { printf '%s' "$got" | sed 's/^/   │ /'; tm_fail "an empty train should render: header, Berths:, 'No passengers tonight.' and nothing else"; }
tm_pass "the manifest renders without stray blank lines, for full and empty trains"
