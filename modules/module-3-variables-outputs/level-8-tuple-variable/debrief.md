# Tuples Need Exact Types

## What Was Broken
`tuple([string, number])` declares positional types: index 0 must be a `string`, index 1 must
be a `number`. The default `["hello", "world"]` provides `"world"` (a string) for position 1.

## The Fix
```hcl
default = ["hello", 42]
```

## `tuple` vs `list`

| Feature        | `list(string)` | `tuple([string, number])` |
|---------------|----------------|--------------------------|
| Element types  | All same       | Each position has its own type |
| Length         | Variable       | Fixed (must match declaration) |
| Index access   | `var.x[0]`     | `var.x[0]`                |

## Tuple Use Cases
Tuples are useful when you need a fixed-length, heterogeneous sequence:
```hcl
# [host, port]
variable "endpoint" {
  type    = tuple([string, number])
  default = ["localhost", 8080]
}
```

## Why It Matters
Tuples enforce both the **number** of elements and the **type** of each positional element.
This makes them useful for strongly-typed fixed-structure values.