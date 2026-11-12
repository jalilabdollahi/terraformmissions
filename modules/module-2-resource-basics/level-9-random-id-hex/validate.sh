#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "random_id" "batch"' "random_id.batch must stay"
tm_assert_config_lacks 'b64_(url|std)' "the tag must be hexadecimal, not base64"
tm_apply
TAG=$(tm_output_raw batch_tag) || tm_fail "output batch_tag is missing"
[[ "$TAG" =~ ^[0-9a-f]{12}$ ]] || tm_fail "batch tag '$TAG' is not 12 lowercase hex characters"
[[ "$TAG" == "$(tm_state_attr random_id.batch hex | cut -c1-12)" ]] || tm_fail "the tag is not derived from random_id.batch.hex"
tm_assert_file "logbook/batch-$TAG.txt" "logbook/batch-$TAG.txt does not exist"
tm_assert_file_equals "logbook/batch-$TAG.txt" "Batch tag: $TAG
Chemistry: D-76 1+1
Temperature: 20C
"
[[ "$(ls logbook | wc -l | tr -d ' ')" == "1" ]] || tm_fail "logbook/ contains more than one entry (leftover files?)"
tm_assert_no_changes
tm_pass "batch tag $TAG"
