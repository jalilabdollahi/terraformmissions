#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'yamldecode[[:space:]]*\(' "the roster must still be read with yamldecode()"
tm_assert_config_has 'file[[:space:]]*\(' "the roster must still be read from the YAML file"

tm_apply
tm_assert_output boat "Kittiwake"
tm_assert_output_jq lines '. == ["Okonkwo manual 2.10 lang no","Reyes manual 1.8 lang en","Lindqvist manual 3.0 lang off"]' \
  "lines should read 'Okonkwo manual 2.10 lang no', 'Reyes manual 1.8 lang en', 'Lindqvist manual 3.0 lang off' (YAML turns bare no/off into false and 2.10 into 2.1)"
tm_assert_output on_watch_count 2
tm_assert_file_equals roster/crew.txt "Kittiwake
Okonkwo manual 2.10 lang no
Reyes manual 1.8 lang en
Lindqvist manual 3.0 lang off
"

# The same code must read another (correctly quoted) config, not just this one.
cat > "$TM_TMP/alt.yaml" <<'YAML'
submarine:
  name: Narwhal
  crew:
    - name: Tanaka
      manual: "4.10"
      language: "no"
      on_watch: true
YAML
tm_plan_json -var "config_path=$TM_TMP/alt.yaml"
jq -e '.planned_values.outputs.boat.value == "Narwhal"
  and .planned_values.outputs.lines.value == ["Tanaka manual 4.10 lang no"]
  and .planned_values.outputs.on_watch_count.value == 1' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "the code must read the submarine section of whatever config_path points to"
tm_pass "the roster is read from the right YAML path and the quoted values survive intact"
