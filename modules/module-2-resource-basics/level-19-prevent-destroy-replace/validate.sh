#!/usr/bin/env bash
source "$TM_LIB"

ORIG_LEDGER=$(tm_recall ledger); ORIG_SHELF=$(tm_recall shelf)
[[ -n "$ORIG_LEDGER" && -n "$ORIG_SHELF" ]] || tm_fail "mission state is missing: run 'reset' to restore the level"
tm_assert_config_has 'prefix[[:space:]]*=[[:space:]]*"bunker"' "the shelf label must use the new prefix bunker"
python3 - <<'PY' || tm_fail "random_uuid.ledger must keep prevent_destroy = true"
import re, sys, glob
txt = "".join(open(f).read() for f in glob.glob("*.tf"))
m = re.search(r'resource\s+"random_uuid"\s+"ledger"\s*\{(.*?)\n\}', txt, re.S)
sys.exit(0 if m and re.search(r'prevent_destroy\s*=\s*true', m.group(1)) else 1)
PY
tm_apply
tm_assert_no_changes
[[ "$(tm_state_attr random_uuid.ledger id)" == "$ORIG_LEDGER" ]] || tm_fail "the vault ledger id changed: it must never be replaced"
SHELF=$(tm_state_attr random_pet.shelf_label id)
[[ "$SHELF" == bunker-* ]] || tm_fail "the shelf label is '$SHELF', expected a bunker- prefix"
[[ "$SHELF" != "$ORIG_SHELF" ]] || tm_fail "the shelf label was not replaced"
tm_assert_file_contains vault/catalogue.txt "shelf: $SHELF"
tm_assert_file_contains vault/catalogue.txt "ledger: $ORIG_LEDGER"
tm_pass "shelf label is now $SHELF and the ledger $ORIG_LEDGER is untouched"
