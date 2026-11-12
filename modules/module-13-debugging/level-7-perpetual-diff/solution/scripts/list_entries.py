#!/usr/bin/env python3
"""Lists the encyclopedia entries held in the press archive (a set, so no inherent order)."""
import json
import sys

sys.stdin.read()
entries = {"volcano-1920", "tundra-1954", "aqueduct-1887", "zeppelin-1991", "monsoon-1932"}
print(json.dumps({"names": ",".join(entries)}))
