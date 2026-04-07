# Wrong Data Source Address in override_data

## What Was Broken
The `override_data` block referenced `data.local_file.wrong`, but the actual data source in the
configuration is `data.local_file.settings`. Terraform rejected the unknown target.

## override_data Syntax
```hcl
override_data {
  target = data.data_type.data_name  # must match exactly
  values = {
    attribute = "mocked_value"
  }
}
```

## override_data vs override_resource
| Block               | Targets          | Use Case |
|---------------------|------------------|----------|
| `override_resource` | Managed resources | Replace resource CRUD |
| `override_data`     | Data sources     | Replace data source reads |

## Why It Matters
Data sources often read from external systems (APIs, cloud services). `override_data` lets you
inject known values without external calls, making tests deterministic and offline-capable.