#!/usr/bin/env python3
"""Reads the jumper list and describes the total weight for Terraform's external data source."""
import csv
import json
import pathlib

root = pathlib.Path(__file__).resolve().parent.parent
with open(root / "roster" / "jumpers.csv", newline="") as fh:
    rows = list(csv.DictReader(fh))

result = {
    "master": "Hester Marl",
    "jumpers": len(rows),
    "total_kg": sum(int(r["weight_kg"]) for r in rows),
    "names": [r["name"] for r in rows],
    "limits": {"max_kg": 360},
}
print(json.dumps(result))
