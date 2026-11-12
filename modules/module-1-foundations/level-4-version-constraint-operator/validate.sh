#!/usr/bin/env bash
source "$TM_LIB"

tm_init "terraform init still fails — a provider version constraint is not valid"
tm_assert_config_lacks '=>' "'=>' is not a version operator"
tm_assert_config_lacks '~>=' "'~>=' is not a version operator"
n=$(grep -cE '^[[:space:]]*version[[:space:]]*=[[:space:]]*"[^"]*[0-9]' terraform.tf)
[[ "$n" -ge 2 ]] || tm_fail "both providers should keep a version constraint in terraform.tf"
tm_validate
tm_apply
ticket=$(tm_output_raw winning_ticket) || tm_fail "output winning_ticket is missing"
[[ "$ticket" =~ ^[0-9]+$ && "$ticket" -ge 100 && "$ticket" -le 499 ]] \
  || tm_fail "winning_ticket '$ticket' is not a number between 100 and 499"
tm_assert_file_equals fete/stage-board.txt "Winning ticket: ${ticket}"$'\n'
tm_assert_file .terraform.lock.hcl "no lock file — did terraform init succeed?"
tm_assert_no_changes
tm_pass "constraints are valid, providers installed, ticket $ticket drawn"
