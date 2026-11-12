#!/usr/bin/env python3
"""Reads the shaft probe and reports the readings (stand-in for the real telemetry bus)."""
import json
import sys

sys.stdin.read()
print(json.dumps({
    "shaft": "B",
    "inspector": "R. Voss",
    "readings": {"top": 12, "mid": 148, "bottom": 311},
}))
