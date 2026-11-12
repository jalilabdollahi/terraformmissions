#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record log_id "$(tm_state_attr local_file.inspection_log id)"
tm_record registry_sha "$(tm_state_attr local_file.queen_registry content_sha1)"
