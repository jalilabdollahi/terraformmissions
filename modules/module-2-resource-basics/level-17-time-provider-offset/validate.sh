#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "time_static" "issued"' "time_static.issued must stay: the issue time is frozen once"
tm_assert_config_has 'resource "time_offset" "expiry"' "time_offset.expiry must stay"
tm_assert_config_has 'base_rfc3339[[:space:]]*=[[:space:]]*time_static\.issued\.rfc3339' "the expiry must be computed from the frozen issue time"
tm_apply
ISSUED=$(tm_output_raw coupon_issued) || tm_fail "output coupon_issued is missing"
EXP=$(tm_output_raw coupon_expires) || tm_fail "output coupon_expires is missing"
python3 - "$ISSUED" "$EXP" <<'PY' || tm_fail "coupon_expires ($EXP) is not exactly 14 days after coupon_issued ($ISSUED) in RFC 3339 form"
import sys, re
from datetime import datetime, timedelta
def p(s):
    if not re.match(r"^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d(\.\d+)?(Z|[+-]\d\d:\d\d)$", s): raise SystemExit(1)
    s = s.replace("Z", "+00:00")
    s = re.sub(r"\.(\d{6})\d*", r".\1", s)
    return datetime.fromisoformat(s)
a, b = p(sys.argv[1]), p(sys.argv[2])
sys.exit(0 if b - a == timedelta(days=14) else 1)
PY
tm_assert_file_equals newsletter/coupon.txt "MARIGOLD SPRING SAVER - 15% off
Valid from: $ISSUED
Valid until: $EXP
"
tm_assert_no_changes
tm_pass "coupon runs from $ISSUED to $EXP"
