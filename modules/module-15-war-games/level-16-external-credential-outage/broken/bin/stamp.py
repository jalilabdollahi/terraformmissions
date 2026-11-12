#!/usr/bin/env python3
"""local-exec helper: ask the registry to stamp the permit, then write out/permit-stamp.txt."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import qr_auth  # noqa: E402

region = os.environ.get("QUOTA_REGION", "")
qr_auth.authenticate("stamp", region)

out = os.path.join(qr_auth.ROOT, "out")
os.makedirs(out, exist_ok=True)
with open(os.path.join(out, "permit-stamp.txt"), "w") as fh:
    fh.write("STAMPED vessel %s key %s tonnes %s\n" % (
        os.environ["VESSEL"], os.environ["VESSEL_KEY"], os.environ["QUOTA_TONNES"]))
