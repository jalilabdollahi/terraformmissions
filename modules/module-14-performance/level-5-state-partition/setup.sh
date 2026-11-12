#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record pet "$(tm_state_attr random_pet.yard_name id)"
tm_record gates "$(tm_state_attr random_integer.gate_count result)"
tm_record roster "$(cat cranes/roster.txt)"
