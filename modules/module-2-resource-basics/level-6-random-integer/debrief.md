# Min Greater Than Max

## What Was Broken
`random_integer` requires `min <= max`. When `min = 100` and `max = 10`, no integer satisfies
`100 <= x <= 10`, so the provider correctly rejects the configuration.

## The Fix
```hcl
resource "random_integer" "port" {
  min = 10
  max = 100
}
```

## `random_integer` Attributes

| Attribute | Required | Description |
|----------|----------|-------------|
| `min`    | yes      | Minimum value (inclusive) |
| `max`    | yes      | Maximum value (inclusive) |
| `seed`   | no       | Seed string for reproducible results |
| `keepers`| no       | Map of values that trigger regeneration |

The `result` attribute holds the generated integer.

## Why It Matters
Range validation (`min <= max`) is a common constraint across many resources and programming contexts.
Recognizing this class of error quickly saves debugging time.