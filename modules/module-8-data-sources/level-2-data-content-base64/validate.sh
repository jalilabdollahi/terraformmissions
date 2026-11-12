#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"' "the engraving must still be read through a local_file data source"
tm_assert_config_has 'content_base64' "the copy needs a binary-safe attribute"
tm_assert_config_lacks 'filebase64[[:space:]]*\(|[^_]file[[:space:]]*\(' "read the engraving through the data source, not a file function"

SRC=art/compass-rose.png
cp "$SRC" "$TM_TMP/rose.orig"
trap 'cp "$TM_TMP/rose.orig" "$SRC"' EXIT

tm_apply
tm_assert_file press/rose-proof.png "press/rose-proof.png was not written"
cmp -s "$SRC" press/rose-proof.png || tm_fail "press/rose-proof.png is not a byte-for-byte copy of the engraving"
TM_MSG="the plan is not clean after apply - Terraform keeps seeing the proof as changed" tm_assert_no_changes

# A different binary engraving must be copied too (bytes that are not valid UTF-8).
python3 - <<'PY'
import pathlib
p = pathlib.Path("art/compass-rose.png")
b = bytearray(p.read_bytes())
b += bytes([0xFF, 0xFE, 0x80, 0x00, 0xC3, 0x28, 0xA0, 0xA1])
p.write_bytes(bytes(b))
PY
tm_apply
cmp -s "$SRC" press/rose-proof.png || tm_fail "an edited engraving was not copied byte-for-byte"
TM_MSG="the plan is not clean after re-applying the new engraving" tm_assert_no_changes
tm_pass "the proof is a byte-exact copy and the plan stays clean"
