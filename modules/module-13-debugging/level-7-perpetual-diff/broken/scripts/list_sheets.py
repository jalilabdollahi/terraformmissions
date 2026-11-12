#!/usr/bin/env python3
"""Lists the map sheets held in the guild archive (a set, so no inherent order)."""
import json
import sys

sys.stdin.read()
sheets = {"harbour-1920", "alpine-1954", "delta-1887", "coastline-1991", "upland-1932"}
print(json.dumps({"names": ",".join(sheets)}))
