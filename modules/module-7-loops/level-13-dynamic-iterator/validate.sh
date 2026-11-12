#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'iterator[[:space:]]*=[[:space:]]*class' "keep the custom iterator name: iterator = class"
tm_assert_config_has 'class\.value\.file' "the content block should read the file name through the class iterator"
tm_apply
zipnames() { python3 -c 'import zipfile,sys; print(",".join(sorted(zipfile.ZipFile(sys.argv[1]).namelist())))' "$1"; }
[[ "$(zipnames bundles/week.zip)" == "monday-bowing.txt,tuesday-counting.txt,wednesday-stances.txt" ]] \
  || tm_fail "week.zip should hold the three class files, found: $(zipnames bundles/week.zip)"
t=$(python3 -c 'import zipfile; print(zipfile.ZipFile("bundles/week.zip").read("tuesday-counting.txt").decode())')
[[ "$t" == "Ichi, ni, san." ]] || tm_fail "tuesday-counting.txt has the wrong text: $t"
md5=$(tm_output_raw bundle_md5)
[[ -n "$md5" ]] || tm_fail "bundle_md5 output is empty"
# other classes: the zip must follow the variable
tm_apply -var 'classes=[{file="friday-belts.txt",text="Kuro is black."}]'
[[ "$(zipnames bundles/week.zip)" == "friday-belts.txt" ]] || tm_fail "with one class the zip should only hold friday-belts.txt"
tm_apply
[[ "$(tm_output_raw bundle_md5)" == "$md5" ]] || tm_fail "the bundle checksum should be stable for the same classes"
tm_pass "classes flow through the custom iterator into the zip"
