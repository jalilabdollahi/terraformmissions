#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record master "$(tm_state_attr random_password.box_master result | python3 -c 'import hashlib,sys; print(hashlib.sha256(sys.stdin.buffer.read()).hexdigest())')"
