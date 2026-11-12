#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'count[[:space:]]*=[[:space:]]*var\.snack_bar_open' "the module should still be switched on and off with count"
# open: the module exists once and the outputs describe it
tm_apply
tm_assert_in_state 'module.snack_bar[0].local_file.menu' "module.snack_bar[0] should exist while the snack bar is open"
tm_assert_output_jq menu_path 'type == "string" and endswith("menus/snacks.txt")' "menu_path should be the menu's path (a string) while open"
tm_assert_output_jq menu_items '. == ["slushies","pretzels"]' "menu_items should list the items while open"
tm_assert_file_contains menus/snacks.txt "- pretzels"
# closed: no module instance, null path, empty list - and the plan/apply must not crash
tm_apply -var snack_bar_open=false
tm_assert_not_in_state 'module.snack_bar[0].local_file.menu' "the module should be gone when the snack bar is closed"
tm_assert_no_file menus/snacks.txt "menus/snacks.txt should be removed while the snack bar is closed"
# a null output is not kept in state, so it may be absent or null - but never a string or list
terraform output -json 2>/dev/null | jq -e '(.menu_path.value // null) == null' >/dev/null || tm_fail "menu_path should be null while closed"
tm_assert_output_jq menu_items '. == []' "menu_items should be an empty list while closed"
# open again with other items
tm_apply -var 'snack_items=["churros"]'
tm_assert_output_jq menu_items '. == ["churros"]' "menu_items should follow var.snack_items"
tm_apply
tm_assert_no_changes
tm_pass "outputs cope with zero or one module instances"
