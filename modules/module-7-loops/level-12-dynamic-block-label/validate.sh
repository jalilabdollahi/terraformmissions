#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'dynamic[[:space:]]+"source"' "the repeated block inside archive_file is called source"
tm_apply
tm_assert_file dist/trip-pack.zip "dist/trip-pack.zip was not created"
names=$(python3 -c 'import zipfile,sys; print(",".join(sorted(zipfile.ZipFile("dist/trip-pack.zip").namelist())))')
[[ "$names" == "consent-form.txt,emergency-card.txt,packing-list.txt" ]] || tm_fail "zip should hold the three documents, found: $names"
text=$(python3 -c 'import zipfile; print(zipfile.ZipFile("dist/trip-pack.zip").read("packing-list.txt").decode())')
[[ "$text" == "Raincoat, lunch, two pens." ]] || tm_fail "packing-list.txt inside the zip has the wrong text: $text"
tm_plan_json -var 'documents={"bus-times.txt"="Leave 08:15","allergies.txt"="Ask the nurse"}'
jq -e '[.resource_changes[] | select(.address == "archive_file.trip_pack") | .change.after.source | map(.filename) | sort] == [["allergies.txt","bus-times.txt"]]' \
  "$TM_TMP/plan.json" >/dev/null || tm_fail "the zip entries must follow var.documents (expected allergies.txt and bus-times.txt)"
tm_pass "trip-pack.zip contains exactly the documents in var.documents"
