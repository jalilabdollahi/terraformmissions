# Negative Time Makes No Sense

## What Was Broken
`validity_period_hours` must be a positive integer. A value of `-1` would imply the certificate
expires before it is issued, which is logically impossible and rejected by the provider.

## The Fix
```hcl
validity_period_hours = 8760  # 365 days
```

## Common Validity Periods

| Hours  | Duration |
|--------|----------|
| 24     | 1 day (for testing) |
| 720    | 30 days  |
| 8760   | 1 year   |
| 87600  | 10 years (CA certificates) |

## Why It Matters
Many number attributes have minimum value constraints. Negative durations, zero timeouts, and
other impossible values are caught at validate time. Always use meaningful positive values for
time-based attributes.