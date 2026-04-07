# Duration is a String, Not a Number

## What Was Broken
The `timeouts` block expects duration strings like `"10m"` or `"600s"`. Providing a raw number
(`600`) is a type mismatch — the provider schema expects a string.

## The Fix
```hcl
timeouts {
  create = "10m"
}
```

## Duration String Format
Terraform uses Go's `time.Duration` string format:

| String    | Duration         |
|----------|-----------------|
| `"30s"`   | 30 seconds      |
| `"10m"`   | 10 minutes      |
| `"2h"`    | 2 hours         |
| `"1h30m"` | 1 hour 30 minutes |

## Timeout Operation Keys

| Key      | When it applies     |
|---------|---------------------|
| `create` | Resource creation   |
| `update` | Resource updates    |
| `delete` | Resource deletion   |
| `read`   | Data source reads   |

## Why It Matters
Duration strings appear in many places in Terraform (timeouts, `time_sleep` resources, etc.).
Recognizing the pattern and remembering to quote them prevents type errors.