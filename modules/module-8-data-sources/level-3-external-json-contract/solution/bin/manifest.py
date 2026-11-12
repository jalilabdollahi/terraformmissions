#!/usr/bin/env python3
"""Reads the passenger list and describes the load for Terraform's external data source."""
import csv
import json
import pathlib

root = pathlib.Path(__file__).resolve().parent.parent
with open(root / "manifest" / "passengers.csv", newline="") as fh:
    rows = list(csv.DictReader(fh))

# external requires a flat JSON object whose values are all strings
result = {
    "pilot": "Hester Marl",
    "pax": str(len(rows)),
    "total_kg": str(sum(int(r["weight_kg"]) for r in rows)),
    "names": "|".join(r["name"] for r in rows),
    "max_kg": "360",
}
print(json.dumps(result))
