#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'dynamic[[:space:]]+"source"' "the optional entry should be a dynamic block"
zipnames() { python3 -c 'import zipfile,sys; print(",".join(sorted(zipfile.ZipFile(sys.argv[1]).namelist())))' "$1"; }
# 1. no transcript: the pack must build with only the two fixed documents
tm_apply
[[ "$(zipnames packs/audio-guide.zip)" == "guide-script.txt,stops.txt" ]] \
  || tm_fail "with no transcript the zip should hold guide-script.txt and stops.txt, found: $(zipnames packs/audio-guide.zip)"
# 2. a transcript: a third entry with that text appears
tm_apply -var 'transcript=BIG TEXT for the harbour tour'
[[ "$(zipnames packs/audio-guide.zip)" == "guide-script.txt,stops.txt,transcript-large-print.txt" ]] \
  || tm_fail "with a transcript the zip should also hold transcript-large-print.txt, found: $(zipnames packs/audio-guide.zip)"
t=$(python3 -c 'import zipfile; print(zipfile.ZipFile("packs/audio-guide.zip").read("transcript-large-print.txt").decode())')
[[ "$t" == "BIG TEXT for the harbour tour" ]] || tm_fail "transcript entry has the wrong text: $t"
# 3. back to null: the entry goes away again
tm_apply
[[ "$(zipnames packs/audio-guide.zip)" == "guide-script.txt,stops.txt" ]] || tm_fail "after unsetting the transcript the entry should disappear again"
tm_assert_no_changes
tm_pass "the transcript entry exists only when var.transcript is set"
