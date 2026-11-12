#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record puzzle "$(cat puzzle/*.txt | shasum | cut -d' ' -f1)"
tm_record checksum "$(tm_output_raw checksum)"
