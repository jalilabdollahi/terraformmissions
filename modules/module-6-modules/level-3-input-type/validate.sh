#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'type[[:space:]]*=[[:space:]]*list\(number\)' \
  "the windcheck module must keep its list(number) input"
tm_assert_config_has 'variable[[:space:]]+"gusts"' "the root variable gusts is gone"

tm_init
TM_MSG="terraform apply failed — read what the error says about the type of gusts_kmh" tm_apply

tm_assert_output verdict "fly all kites"
tm_assert_file_equals board/morning.txt $'Skagen Dunes: fly all kites (peak 28 km/h)\n'

TM_MSG="the module could not be applied with a different comma-separated reading" tm_apply -var gusts="15,40"
tm_assert_output verdict "stunt kites only"
tm_assert_file_equals board/morning.txt $'Skagen Dunes: stunt kites only (peak 40 km/h)\n'

tm_apply -var gusts="10,22,48"
tm_assert_output verdict "grounded"

tm_apply
tm_assert_no_changes
tm_pass "the comma-separated gusts reach windcheck as numbers and the verdicts follow the peak"
