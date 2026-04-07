# Self-Referential Error

## What Was Broken
`self.wrong_attr` references an attribute that does not exist. Inside an output's `postcondition`,
`self` exposes only `self.value` — the value of the output.

## The Fix
```hcl
postcondition {
  condition     = self.value != ""
  error_message = "Config path must not be empty."
}
```

## self in Conditions
| Context | self refers to |
|---|---|
| `resource lifecycle precondition/postcondition` | the resource instance |
| `output lifecycle postcondition` | the output value object |

For outputs, `self.value` is the only available attribute.

## Why It Matters
Custom conditions are powerful for encoding assumptions about your infrastructure. An invalid
`self` reference prevents the condition from running at all.