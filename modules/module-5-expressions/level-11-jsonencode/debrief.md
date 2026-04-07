# JSON Encode

## What Was Broken
`timestamp()` returns the current UTC time as a string. Every plan run produces a different value,
making the JSON non-deterministic. This causes permanent drift: every plan shows a change.

## The Fix
```hcl
locals {
  config = {
    name    = "app"
    version = "1.0.0"
  }
  config_json = jsonencode(local.config)
}
```

## jsonencode() Usage
```hcl
jsonencode({name = "app", port = 8080})
# → "{"name":"app","port":8080}"

jsonencode(["a", "b", "c"])
# → "["a","b","c"]"
```

## Why It Matters
Plan stability is critical for CI/CD pipelines. Non-deterministic values (timestamps, random
IDs) in config cause permanent "changes detected" that mask real infrastructure drift.