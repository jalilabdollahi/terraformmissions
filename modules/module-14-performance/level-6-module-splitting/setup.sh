#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record batch "$(tm_state_attr module.workshop.random_id.batch hex)"
tm_record label "$(cat out/label.txt)"
