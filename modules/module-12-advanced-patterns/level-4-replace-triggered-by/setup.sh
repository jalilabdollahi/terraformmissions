#!/usr/bin/env bash
source "$TM_LIB"
# The cabinet currently runs firmware 3.1. Apply that version, remember the IDs, restore today's code.
cp main.tf "$TM_TMP/main.tf.release"
cp "$LEVEL_PATH/legacy/main.tf" main.tf
tm_apply
tm_record cabinet_id "$(tm_state_attr terraform_data.cabinet id)"
tm_record cal_id "$(tm_state_attr terraform_data.calibration id)"
tm_record fw_id "$(tm_state_attr terraform_data.firmware_pack id)"
cp "$TM_TMP/main.tf.release" main.tf
