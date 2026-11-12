#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "random_password" "audio_guide"' "the audio_guide password resource must stay"
tm_assert_config_lacks 'result[[:space:]]*=' "the password must be generated, not typed in"
tm_apply
PW=$(tm_output_raw audio_guide_password) || tm_fail "output audio_guide_password is missing"
[[ ${#PW} -eq 12 ]] || tm_fail "password has ${#PW} characters, expected 12"
python3 - "$PW" <<'PY' || tm_fail "password does not contain at least 2 uppercase, 2 lowercase, 2 digit and 2 special characters"
import sys
p = sys.argv[1]
u = sum(c.isupper() for c in p); l = sum(c.islower() for c in p)
d = sum(c.isdigit() for c in p); s = sum(not c.isalnum() for c in p)
sys.exit(0 if min(u, l, d, s) >= 2 else 1)
PY
tm_assert_file_contains ticket-desk/daypass-voucher.txt "Password: $PW"
tm_assert_config_has 'sensitive[[:space:]]*=[[:space:]]*true' "keep the password output marked sensitive"
tm_assert_no_changes
tm_pass "12-character password with all four character classes"
