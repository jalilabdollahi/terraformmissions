# Type Conversion Tangle

## What Was Broken
`tomap(["a","b","c"])` cannot convert a list to a map because there are no keys.
A map requires key-value pairs: `{key = value}`.

## The Fix
```hcl
locals {
  items = tolist(["a", "b", "c"])
}
```
`tolist()` on a literal list is valid (and often redundant, as the list is already a list).

## Type Conversion Functions
| Function | Input → Output |
|---|---|
| `tolist(list)` | tuple/set → list |
| `toset(list)` | list/tuple → set |
| `tomap(map)` | object → map |
| `tostring(value)` | primitive → string |

## Why It Matters
Type conversion errors are caught at validate time. Understanding what each function accepts
saves trial-and-error debugging.