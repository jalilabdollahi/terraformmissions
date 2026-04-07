# Script Doesn't Speak JSON

## What Was Broken
The Python script output plain text (`version=1.0`) instead of a JSON object. The `external`
data source contract requires the program to write a flat JSON object (string-to-string map) to stdout.

## The Fix
```python
#!/usr/bin/env python3
import json
print(json.dumps({"version": "1.0"}))
```

## External Data Source Contract
1. The program reads an optional JSON query from stdin.
2. It writes a flat JSON object (all values must be strings) to stdout.
3. It exits with code 0 on success, non-zero on failure.
4. Any stderr output is shown as a Terraform error.

## Why It Matters
The `data "external"` source is the escape hatch for calling arbitrary programs. Adhering to the
JSON contract is mandatory — even a single extra line of non-JSON output causes a failure.