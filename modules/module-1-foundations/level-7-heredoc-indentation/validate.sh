#!/usr/bin/env bash
source "$TM_LIB"

tm_validate
tm_assert_config_has '<<-' "this mission wants the indented heredoc operator (<<-) so the config can stay nicely indented"
tm_apply
tm_assert_file_equals tavern/menu.txt $'Tonight at the Copper Kettle\n  - Soup: leek and barley\n  - Roast pheasant, juniper jus\n  - Treacle tart\nKitchen closes at 21:30\n'
tm_apply -var 'soup=nettle'
tm_assert_file_contains tavern/menu.txt "  - Soup: nettle" "the soup line should still come from var.soup"
tm_apply
tm_assert_output menu_lines 5
tm_assert_no_changes
tm_pass "the menu keeps its relative indentation and starts at column 0"
