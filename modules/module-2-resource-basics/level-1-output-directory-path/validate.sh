#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "local_file" "bake_sheet"' "the bake_sheet resource must stay"
tm_apply
tm_assert_file out/bake-sheet.txt "out/bake-sheet.txt does not exist"
tm_assert_no_file bake-sheet.txt "a stray bake-sheet.txt is still sitting in the project root"
tm_assert_file_equals out/bake-sheet.txt "BAKE SHEET
focaccia   x 18
rye        x 12
sourdough  x 24
"
tm_assert_file out/price-labels.txt "the price labels went missing"
P=$(tm_output_raw bake_sheet_path) || tm_fail "output bake_sheet_path is missing"
case "$P" in */out/bake-sheet.txt) ;; *) tm_fail "output bake_sheet_path = '$P' does not point into out/" ;; esac
tm_assert_output total_loaves 54
tm_assert_no_changes
tm_pass "bake sheet is filed under out/ next to the price labels"
