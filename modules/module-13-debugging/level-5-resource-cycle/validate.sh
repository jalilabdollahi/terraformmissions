#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource[[:space:]]+"local_file"[[:space:]]+"net_roster"' "net_roster must stay"
tm_assert_config_has 'resource[[:space:]]+"local_file"[[:space:]]+"net_schedule"' "net_schedule must stay"
tm_assert_config_has 'content_sha256' "the roster must quote a checksum computed by Terraform"
tm_assert_config_lacks '[0-9a-f]{64}' "do not type the checksum into the config"
tm_assert_config_lacks 'depends_on' "depends_on cannot break a cycle - it only adds edges"

tm_validate "terraform validate still reports a problem (a cycle?)"
tm_apply
tm_assert_no_changes
tm_assert_no_changes

ROSTER=net/roster.txt
SCHED=net/schedule.txt
tm_assert_file "$ROSTER" "net/roster.txt was not written"
tm_assert_file "$SCHED" "net/schedule.txt was not written"
REAL=$(python3 -c 'import hashlib,sys;print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())' "$SCHED")
tm_assert_file_contains "$ROSTER" "schedule checksum: $REAL" \
  "the roster does not quote the real SHA-256 of net/schedule.txt"
tm_assert_file_contains "$SCHED" "net/roster.txt" "the schedule must still point to net/roster.txt"
tm_assert_file_contains "$ROSTER" "net control: K9BRK" "the roster lost its content"
tm_assert_output roster_checksum_line "schedule checksum: $REAL"
tm_pass "the roster quotes the schedule's checksum and the cycle is gone"
