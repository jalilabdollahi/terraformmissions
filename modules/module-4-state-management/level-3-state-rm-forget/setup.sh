#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record log_id "$(tm_state_attr local_file.vet_log id)"
tm_record book_sha "$(tm_state_attr local_file.stud_book content_sha1)"
