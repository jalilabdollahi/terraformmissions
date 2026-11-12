#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'iterator[[:space:]]*=[[:space:]]*lesson' "keep the custom iterator name: iterator = lesson"
tm_assert_config_has 'lesson\.value\.file' "the content block should read the file name through the lesson iterator"
tm_apply
zipnames() { python3 -c 'import zipfile,sys; print(",".join(sorted(zipfile.ZipFile(sys.argv[1]).namelist())))' "$1"; }
[[ "$(zipnames bundles/week.zip)" == "monday-greetings.txt,tuesday-numbers.txt,wednesday-food.txt" ]] \
  || tm_fail "week.zip should hold the three lesson files, found: $(zipnames bundles/week.zip)"
t=$(python3 -c 'import zipfile; print(zipfile.ZipFile("bundles/week.zip").read("tuesday-numbers.txt").decode())')
[[ "$t" == "Bat, bi, hiru." ]] || tm_fail "tuesday-numbers.txt has the wrong text: $t"
md5=$(tm_output_raw bundle_md5)
[[ -n "$md5" ]] || tm_fail "bundle_md5 output is empty"
# other lessons: the zip must follow the variable
tm_apply -var 'lessons=[{file="friday-colours.txt",text="Gorria is red."}]'
[[ "$(zipnames bundles/week.zip)" == "friday-colours.txt" ]] || tm_fail "with one lesson the zip should only hold friday-colours.txt"
tm_apply
[[ "$(tm_output_raw bundle_md5)" == "$md5" ]] || tm_fail "the bundle checksum should be stable for the same lessons"
tm_pass "lessons flow through the custom iterator into the zip"
