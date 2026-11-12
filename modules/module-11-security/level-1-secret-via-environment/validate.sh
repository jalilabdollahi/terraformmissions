#!/usr/bin/env bash
source "$TM_LIB"
SECRET="demo-not-a-real-secret-cable-7731"
export TF_VAR_landing_password="$SECRET"

tm_validate "the configuration does not validate"
tm_apply
LOG=logs/handshake.log
tm_assert_file "$LOG" "the handshake script never ran, so logs/handshake.log does not exist"

if grep -qF -- "$SECRET" "$LOG"; then
  tm_fail "the password was passed on the command line — it is visible in the script's argv (and in 'ps')"
fi
ARGV=$(grep '^argv:' "$LOG")
[[ "$ARGV" == *"--site brest-landing"* ]] || tm_fail "the handshake must still be called with --site brest-landing (got: $ARGV)"

WANT=$(printf '%s' "$SECRET" | python3 -c 'import hashlib,sys; print(hashlib.sha256(sys.stdin.buffer.read()).hexdigest())')
GOT=$(sed -n 's/^env_digest: //p' "$LOG")
[[ "$GOT" == "$WANT" ]] || tm_fail "the script did not receive the password through its environment (LANDING_PASSWORD)"

tm_assert_no_changes
tm_pass "the handshake got the password via LANDING_PASSWORD and it never appeared in argv"
