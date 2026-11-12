#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'content_base64' "the badge must be written from its base64 form"
tm_assert_config_has 'resource "local_file" "board_header"' "the header file resource must stay"
tm_apply
tm_assert_file signage/lift-closed.png
python3 - <<'PY' || tm_fail "signage/lift-closed.png is not the expected binary PNG (it looks like text, not decoded bytes)"
import base64, hashlib, sys
data = open("signage/lift-closed.png", "rb").read()
want = base64.b64decode("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==")
sys.exit(0 if data == want and data[:8] == b"\x89PNG\r\n\x1a\n" else 1)
PY
tm_assert_file_equals signage/header.txt "PINECREST RIDGE - LIFT STATUS
"
SHA=$(tm_output_raw badge_sha256) || tm_fail "output badge_sha256 is missing"
GOT=$(python3 -c 'import hashlib;print(hashlib.sha256(open("signage/lift-closed.png","rb").read()).hexdigest())')
[[ "$SHA" == "$GOT" ]] || tm_fail "badge_sha256 output does not match the file on disk"
tm_assert_no_changes
tm_pass "the CLOSED badge is a genuine PNG"
