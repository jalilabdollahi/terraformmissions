#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_lacks 'file\(' "file() reads from disk while Terraform is still planning - use the value Terraform already holds"
tm_assert_config_lacks 'templatefile\(' "templatefile() has the same plan-time read problem here"
tm_assert_config_lacks 'data[[:space:]]+"local_file"' "reading the file back through a data source is not the fix for this mission"
tm_assert_config_has 'local_file"[[:space:]]+"session_notes"' "the notes resource must stay"
tm_assert_config_has 'local_file"[[:space:]]+"track_sheet"' "the track sheet resource must stay"

# The proof that no stray file is helping: planning from nothing must work in a scratch copy.
SCRATCH="$TM_TMP/fresh"
mkdir -p "$SCRATCH"
for f in *.tf; do cp "$f" "$SCRATCH/"; done
[[ -d .terraform ]] && cp -R .terraform "$SCRATCH/.terraform"
[[ -f .terraform.lock.hcl ]] && cp .terraform.lock.hcl "$SCRATCH/"
if ! (cd "$SCRATCH" && terraform plan -input=false -no-color >"$TM_TMP/fresh-plan.txt" 2>&1); then
  sed 's/^/   | /' "$TM_TMP/fresh-plan.txt" | head -20
  tm_fail "a fresh checkout (without the studio/ folder) still cannot be planned"
fi

tm_apply
tm_assert_no_changes
tm_assert_no_changes
tm_assert_output take_count "3"
tm_assert_file_contains studio/notes.txt "take 2: good" "studio/notes.txt was not written from the takes"
tm_assert_file_contains studio/track-sheet.txt "Session notes (3 takes):" "the track sheet header is wrong"
tm_assert_file_contains studio/track-sheet.txt "take 3: fade out early" "the track sheet does not quote the notes"
tm_pass "a fresh checkout plans and applies, and the sheet quotes Terraform's own notes"
