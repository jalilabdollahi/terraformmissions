# Version Constraint Clash

## What Was Broken
`module_a` required `~> 2.4` (any 2.x at or above 2.4) and `module_b` required `>= 3.0`.
There is no version that is simultaneously in the 2.x range AND at or above 3.0.

## The Fix
Align both modules to a compatible constraint:
```hcl
version = "~> 2.5"
```

## Version Constraint Operators
| Operator | Meaning |
|---|---|
| `~> 2.5` | `>= 2.5, < 3.0` |
| `>= 2.5` | 2.5 or higher |
| `>= 2.5, < 3.0` | explicit range |
| `= 2.5.1` | exact version |

## Why It Matters
Provider version conflicts are common when composing modules from different sources.
Always check that all modules in a configuration agree on compatible version ranges.