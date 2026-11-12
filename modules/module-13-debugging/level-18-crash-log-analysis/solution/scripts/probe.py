#!/usr/bin/env python3
"""Reads the shaft probe and reports the readings (stand-in for the real telemetry bus)."""
import json
import sys

sys.stdin.read()
# The external data source only accepts a flat map of strings, so nested data travels as JSON text.
print(json.dumps({
    "shaft": "B",
    "inspector": "R. Voss",
    "readings": json.dumps({"top": 12, "mid": 148, "bottom": 311}),
}))
