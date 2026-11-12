#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"' \
  "the tuning sheet must still be read through a local_file data source"
tm_assert_config_lacks '29|Tenor Lead' \
  "the pan name and note count must come from the sheet, not be typed into the config"

tm_apply
tm_assert_output pan_name "Tenor Lead"
tm_assert_output note_count 29
tm_assert_file_contains out/pan-card.txt "Notes to tune: 29" "pan card does not show the note count from the sheet"

cp sheets/tenor-lead.txt "$TM_TMP/sheet.orig"
trap 'cp "$TM_TMP/sheet.orig" sheets/tenor-lead.txt' EXIT
# The sheet is the source of truth: change it and the card must follow.
python3 - <<'PY'
import pathlib
p = pathlib.Path("sheets/tenor-lead.txt")
p.write_text(p.read_text().replace("notes: 29", "notes: 32").replace("Tenor Lead", "Double Second"))
PY
tm_apply
tm_assert_output pan_name "Double Second"
tm_assert_output note_count 32
tm_assert_file_contains out/pan-card.txt "Pan: Double Second" "pan card did not follow the edited sheet"
tm_pass "the pan card is built from whatever the sheet in sheets/ says"
