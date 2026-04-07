# String Is Not a List

## What Was Broken
`data.local_file.services.content` returns a raw string. A `for` expression cannot iterate
over a string as if it were a list. `jsondecode()` must be called first to convert the JSON
string to a native Terraform list.

## The Fix
```hcl
locals {
  enabled_services = [
    for s in jsondecode(data.local_file.services.content) : s if s.enabled
  ]
}
```

## Pattern: Read JSON - Decode - Filter
```hcl
data "local_file" "config" {
  filename = "${path.module}/config.json"
}

locals {
  items   = jsondecode(data.local_file.config.content)
  active  = [for item in local.items : item if item.active]
}
```

## Why This Matters
JSON files are commonly used as configuration sources in Terraform. Remember that
`local_file.content` always returns a string — parsing is your responsibility.