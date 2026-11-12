#!/usr/bin/env bash
source "$TM_LIB"

TAG=$(tm_recall tag_id); LABEL=$(tm_recall label_id)
[[ -n "$TAG" && -n "$LABEL" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_id" "freezer_tag"' "the freezer_tag resource must stay in the configuration"
tm_assert_config_lacks 'import[[:space:]]*\{' "this mission uses the terraform import command, not an import block"

tm_assert_in_state random_id.freezer_tag "random_id.freezer_tag is not in state yet — nothing has been imported"

CURRENT=$(tm_state_attr random_id.freezer_tag b64_url)
if [[ "$CURRENT" != "$TAG" ]]; then
  HEX=$(tm_state_attr random_id.freezer_tag hex)
  tm_fail "the freezer tag in state is '$CURRENT' (hex $HEX) but the sticker says '$TAG' — the wrong value was imported or a new one was generated"
fi

[[ "$(tm_state_attr local_file.door_label id)" == "$LABEL" ]] || tm_fail "the door label would be rewritten — the imported tag does not match the label on the door"
tm_assert_no_changes
tm_assert_file_contains labels/freezer-door.txt "$(tm_state_attr random_id.freezer_tag hex)" "the door label does not show the imported tag"
tm_pass "the freezer keeps its original asset tag ($TAG) and Terraform manages it again"
