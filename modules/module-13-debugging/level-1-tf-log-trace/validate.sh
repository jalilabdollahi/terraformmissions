#!/usr/bin/env bash
source "$TM_LIB"

# --- the written diagnosis -------------------------------------------------
ANS=answers/trace.txt
tm_assert_file "$ANS" "answers/trace.txt does not exist yet - record what the trace told you"
get() { grep -E "^$1=" "$ANS" | head -n1 | cut -d= -f2- | tr -d '[:space:]'; }
RES=$(get failed_resource)
RPC=$(get failed_rpc)
VER=$(get provider_version)
[[ "$RES" == "local_file.beacon_probe" ]] \
  || tm_fail "failed_resource is '$RES' - that is not the resource whose call returned the error"
[[ "$RPC" == "ApplyResourceChange" ]] \
  || tm_fail "failed_rpc is '$RPC' - was the error raised while planning or while applying?"
LOCKED=$(awk '/provider "registry.terraform.io\/hashicorp\/local"/{f=1} f && /^[[:space:]]*version/{gsub(/[" ]/,"",$3); print $3; exit}' .terraform.lock.hcl)
[[ -n "$LOCKED" ]] || tm_fail "no lock file entry for the local provider - is terraform init working?"
[[ "$VER" == "$LOCKED" ]] \
  || tm_fail "provider_version is '$VER' - the trace shows the version of the plugin binary that was started"
[[ "$(wc -l < "$ANS" | tr -d ' ')" -le 4 ]] || tm_fail "answers/trace.txt should hold just the three key=value lines"

# --- the repair --------------------------------------------------------------
tm_assert_config_has 'hashicorp/local' "the local provider must stay in use"
tm_assert_config_has 'local_file"[[:space:]]+"beacon_probe"' "the beacon_probe resource must still exist"
tm_assert_config_lacks 'depends_on' "ordering was never the problem here - fix the path"
tm_apply
tm_assert_no_changes
tm_assert_no_changes

[[ -f field/beacons/index.txt ]] || tm_fail "field/beacons/index.txt must be a regular file listing the beacons"
[[ "$(grep -c kHz field/beacons/index.txt)" == "3" ]] || tm_fail "the beacon index should list three beacons"
PROBE=$(tm_state_attr local_file.beacon_probe filename)
[[ -n "$PROBE" ]] || tm_fail "local_file.beacon_probe is not in state"
case "$PROBE" in
  *index.txt/*) tm_fail "the probe marker is still being written inside the index file's path" ;;
esac
IDX=$(tm_state_attr local_file.beacon_index filename)
[[ "$(dirname "${PROBE#./}")" == "$(dirname "${IDX#./}")" ]] \
  || tm_fail "the probe marker must sit in the same directory as the index"
tm_assert_file_contains "$PROBE" "all 3 transceivers answered"
tm_pass "diagnosis recorded ($RES / $RPC / local $VER) and the beacon sheets are written"
