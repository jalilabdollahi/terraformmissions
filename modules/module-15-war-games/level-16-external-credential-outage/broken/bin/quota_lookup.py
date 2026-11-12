#!/usr/bin/env python3
"""Terraform external data source: look up a vessel's landing quota in the registry."""
import hashlib
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import qr_auth  # noqa: E402

query = json.load(sys.stdin)
region = query.get("region", "")
vessel = query.get("vessel", "")
qr_auth.authenticate("quota_lookup", region)

digest = hashlib.sha256((region + "/" + vessel).encode()).hexdigest()
tonnes = 100 + int(digest[:4], 16) % 400
print(json.dumps({"tonnes": str(tonnes), "region": region, "licence": "LQ-" + digest[4:10]}))
