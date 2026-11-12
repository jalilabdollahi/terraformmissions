#!/usr/bin/env bash
source "$TM_LIB"

tm_init
TM_MSG="terraform apply failed" tm_apply

tm_assert_in_state module.evaporator.module.canner.local_file.tin_label \
  "the label must be written by module.evaporator.module.canner — keep both module levels"
tm_assert_output label "Hollisford Sugarbush syrup, season 2023"
tm_assert_file_equals syrup/hollisford-2023.txt $'Hollisford Sugarbush syrup, season 2023\n'
tm_assert_no_file syrup/hollisford-unknown.txt "a label with season 'unknown' was written"

tm_apply -var season=2019
tm_assert_output label "Hollisford Sugarbush syrup, season 2019"
tm_assert_file_equals syrup/hollisford-2019.txt $'Hollisford Sugarbush syrup, season 2019\n'
tm_assert_no_file syrup/hollisford-unknown.txt "a label with season 'unknown' was written"

# keep the canner's default as a safety net: the fix is the missing hop, not removing the default
tm_assert_config_has 'default[[:space:]]*=[[:space:]]*"unknown"' "leave the canner's fallback as it is; wire the value through instead"

tm_apply
tm_assert_no_changes
tm_pass "season flows root -> evaporator -> canner"
