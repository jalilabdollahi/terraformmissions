#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record map_id "$(tm_state_attr local_file.stall_map id)"
tm_record book_sha "$(tm_state_attr local_file.permit_book content_sha1)"
