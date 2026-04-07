# Lookup Function

## What Was Broken
`lookup()` requires exactly 3 arguments: the map, the key, and the default value.
Calling it with 2 arguments is a validation error.

## The Fix
```hcl
locals {
  port = lookup(var.config, "port", 8080)
}
```

## lookup() vs Direct Access
```hcl
# Direct access — errors if key doesn't exist
var.config["port"]

# lookup with default — safe, returns default if key missing
lookup(var.config, "port", 8080)

# can also be written as:
try(var.config["port"], 8080)
```

## Why It Matters
`lookup()` provides safe map access with a fallback, which is essential when working with
optional configuration maps where not all keys are guaranteed to be present.