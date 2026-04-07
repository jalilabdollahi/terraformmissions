# Iterator Identity Crisis

## What Was Broken
The inner `for` loop reused the variable name `env`, shadowing the outer `env`. Inside the inner
loop, `env` referred to the region string, not the environment name. This produced pairs like
`us-east-1:us-east-1` instead of `prod:us-east-1`.

## The Fix Pattern
```hcl
# Wrong — shadowing
for env in keys(local.environments) : [
  for env in local.environments[env] : "${env}:${env}"
]

# Correct — unique names
for env_name in keys(local.environments) : [
  for region in local.environments[env_name] : "${env_name}:${region}"
]
```

## Dynamic Block Equivalent
For `dynamic` blocks, use the `iterator` argument to name the iteration variable:
```hcl
dynamic "outer" {
  for_each = var.outer_items
  iterator = outer_item
  content {
    dynamic "inner" {
      for_each = outer_item.value.sub_items
      iterator = inner_item   # unique name prevents shadowing
      content {
        label = "${outer_item.value.name}:${inner_item.value}"
      }
    }
  }
}
```

## Why It Matters
Iterator shadowing is a subtle logic bug — the configuration is syntactically valid but
produces incorrect values at runtime.