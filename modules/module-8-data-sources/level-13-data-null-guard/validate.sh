#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"' "the guest list must still be read through a local_file data source"

tm_apply
tm_assert_output special_diets 2
tm_assert_output_jq cards '. == ["Ottoline Brace | table 3 | vegan","Cedric Hale | table 3 | no restrictions","Prudence Voss | table 5 | no restrictions","Ambrose Tull | table TBA | nut allergy"]' \
  "cards should have one line per guest, with defaults for missing table and diet"
tm_assert_file_contains event/place-cards.txt "Ambrose Tull | table TBA | nut allergy"

# A different list with other combinations of missing and null values.
cp event/guests.json "$TM_TMP/guests.orig"
trap 'cp "$TM_TMP/guests.orig" event/guests.json' EXIT
cat > event/guests.json <<'JSON'
[
  {"name": "Una Marsh", "table": 1},
  {"name": "Bede Fox", "table": null, "diet": "halal"},
  {"name": "Sorrel Kane"},
  {"name": "Tilda Oak", "table": 12, "diet": "coeliac"}
]
JSON
tm_apply
tm_assert_output special_diets 2
tm_assert_output_jq cards '. == ["Una Marsh | table 1 | no restrictions","Bede Fox | table TBA | halal","Sorrel Kane | table TBA | no restrictions","Tilda Oak | table 12 | coeliac"]' \
  "cards did not handle null or missing values in the edited list"
tm_pass "every guest gets a card whatever optional fields are absent or null"
