#!/usr/bin/env python3
"""Prints the oxygen level from the survey readings as a flat JSON object of strings."""
import json
import pathlib

readings = {}
for line in (pathlib.Path(__file__).resolve().parent.parent / "survey" / "readings.txt").read_text().splitlines():
    if "=" in line:
        k, v = line.split("=", 1)
        readings[k] = v
print(json.dumps({"o2_pct": readings["o2_pct"]}))
