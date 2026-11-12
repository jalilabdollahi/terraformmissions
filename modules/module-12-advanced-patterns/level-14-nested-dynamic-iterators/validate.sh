#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'dynamic[[:space:]]+"source"' "the zip entries must still come from a dynamic \"source\" block"
tm_assert_config_has 'for[[:space:]]+[a-z_]+[[:space:]]*,[[:space:]]*[a-z_]+[[:space:]]+in[[:space:]]+var\.workshops' "keep looping over var.workshops"

tm_validate "the configuration does not validate"
tm_apply

ZIP=$(tm_output_raw kit_path)
[[ -n "$ZIP" && -f "$ZIP" ]] || tm_fail "the kit zip was not produced"

LISTING=$(python3 - "$ZIP" <<'PY'
import sys, zipfile
z = zipfile.ZipFile(sys.argv[1])
for n in sorted(z.namelist()):
    print(n + "|" + z.read(n).decode().strip())
PY
)
EXPECT=$'east/satchel.txt|stitch sheet for satchel\nnorth/belt.txt|stitch sheet for belt\nnorth/wallet.txt|stitch sheet for wallet'
[[ "$LISTING" == "$EXPECT" ]] || {
  echo "   zip contains:"; sed 's/^/   │ /' <<<"$LISTING"
  tm_fail "the kit must hold exactly east/satchel.txt, north/belt.txt and north/wallet.txt"
}
tm_assert_no_changes
tm_pass "the kit zip holds one correctly named entry per piece"
