#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'path\.module[^)]*templates/header\.txt' "load header.txt through path.module and the templates/ folder"
tm_assert_config_has 'path\.module[^)]*templates/footer\.txt' "load footer.txt through path.module and the templates/ folder"
tm_validate
tm_apply
h=$(cat templates/header.txt; echo x); h=${h%x}
f=$(cat templates/footer.txt; echo x); f=${f%x}
expected="Dear Aunt Bettina,"$'\n\n'"${h}"$'\n'"${f}"
tm_assert_file_equals letters/invitation.txt "$expected" "the letter must be built from the real template files"
# the snippets must be read from disk, not copied into the config
tm_assert_config_lacks 'wedding of Marta' "do not paste the snippet text into the config — read it from templates/"
tm_assert_no_changes
tm_pass "snippets are loaded from the module directory and the letter is assembled"
