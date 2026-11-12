#!/usr/bin/env python3
"""Reports what is really on disk for the file named in the query (JSON in, JSON out)."""
import json, os, stat, sys

query = json.load(sys.stdin)
path = query["path"]
if not os.path.exists(path):
    print(json.dumps({"exists": "false", "mode": ""}))
else:
    mode = stat.S_IMODE(os.stat(path).st_mode)
    print(json.dumps({"exists": "true", "mode": format(mode, "o")}))
