#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'local_file\.catalogue\.content_sha256' "take the checksum from the resource's own exported attribute"
tm_assert_config_lacks 'filesha256|[^_]sha256[[:space:]]*\(' "don't recompute the hash by hand — read the attribute the resource exports"

tm_apply
tm_assert_file archive/catalogue.csv
expected_sum=$(python3 -c 'import hashlib,sys;print(hashlib.sha256(open("archive/catalogue.csv","rb").read()).hexdigest())')
tm_assert_output catalogue_checksum "$expected_sum"
fname=$(tm_state_attr local_file.catalogue filename)
tm_assert_output catalogue_path "$fname"
tm_assert_output licence_total "43"
tm_pass "outputs read the attributes local_file really exports (filename, content_sha256)"
