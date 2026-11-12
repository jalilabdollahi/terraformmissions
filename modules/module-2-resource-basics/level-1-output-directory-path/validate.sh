#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "local_file" "shift_board"' "the shift_board resource must stay"
tm_apply
tm_assert_file out/shift-board.txt "out/shift-board.txt does not exist"
tm_assert_no_file shift-board.txt "a stray shift-board.txt is still sitting in the project root"
tm_assert_file_equals out/shift-board.txt "SHIFT BOARD
puzzle     x 18
robot      x 12
teddy      x 24
"
tm_assert_file out/pallet-labels.txt "the pallet labels went missing"
P=$(tm_output_raw shift_board_path) || tm_fail "output shift_board_path is missing"
case "$P" in */out/shift-board.txt) ;; *) tm_fail "output shift_board_path = '$P' does not point into out/" ;; esac
tm_assert_output total_toys 54
tm_assert_no_changes
tm_pass "shift board is filed under out/ next to the pallet labels"
