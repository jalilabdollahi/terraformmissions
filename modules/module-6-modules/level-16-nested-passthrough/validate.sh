#!/usr/bin/env bash
source "$TM_LIB"

tm_init
TM_MSG="terraform apply failed" tm_apply

tm_assert_in_state module.press.module.bottler.local_file.bottle_label \
  "the label must be written by module.press.module.bottler — keep both module levels"
tm_assert_output label "Applewick Orchard cider, vintage 2023"
tm_assert_file_equals cider/applewick-2023.txt $'Applewick Orchard cider, vintage 2023\n'
tm_assert_no_file cider/applewick-unknown.txt "a label with vintage 'unknown' was written"

tm_apply -var vintage=2019
tm_assert_output label "Applewick Orchard cider, vintage 2019"
tm_assert_file_equals cider/applewick-2019.txt $'Applewick Orchard cider, vintage 2019\n'
tm_assert_no_file cider/applewick-unknown.txt "a label with vintage 'unknown' was written"

# keep the bottler's default as a safety net: the fix is the missing hop, not removing the default
tm_assert_config_has 'default[[:space:]]*=[[:space:]]*"unknown"' "leave the bottler's fallback as it is; wire the value through instead"

tm_apply
tm_assert_no_changes
tm_pass "vintage flows root -> press -> bottler"
