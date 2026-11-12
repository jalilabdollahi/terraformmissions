#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"' \
  "the tuning sheet must still be read through a local_file data source"
tm_assert_config_lacks '56|Principal 8' \
  "the stop name and pipe count must come from the sheet, not be typed into the config"

tm_apply
tm_assert_output stop_name "Principal 8'"
tm_assert_output pipe_count 56
tm_assert_file_contains out/chest-card.txt "Pipes to voice: 56" "chest card does not show the pipe count from the sheet"

cp sheets/principal-8.txt "$TM_TMP/sheet.orig"
trap 'cp "$TM_TMP/sheet.orig" sheets/principal-8.txt' EXIT
# The sheet is the source of truth: change it and the card must follow.
python3 - <<'PY'
import pathlib
p = pathlib.Path("sheets/principal-8.txt")
p.write_text(p.read_text().replace("pipes: 56", "pipes: 61").replace("Principal 8'", "Octave 4'"))
PY
tm_apply
tm_assert_output stop_name "Octave 4'"
tm_assert_output pipe_count 61
tm_assert_file_contains out/chest-card.txt "Stop: Octave 4'" "chest card did not follow the edited sheet"
tm_pass "the chest card is built from whatever the sheet in sheets/ says"
