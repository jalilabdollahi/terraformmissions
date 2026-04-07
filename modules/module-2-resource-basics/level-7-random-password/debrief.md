# More Than the Sum of Its Parts

## What Was Broken
The individual minimum character-class requirements totaled more than the password length:

```
min_upper (2) + min_lower (2) + min_numeric (2) = 6 > length (5)
```

The provider cannot construct a password that satisfies all constraints simultaneously.

## The Fix
Increase `length` to be at least the sum of all minimums:

```hcl
resource "random_password" "db_pass" {
  length      = 10
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  special     = false
}
```

## Minimum Character Attributes

| Attribute      | Description |
|---------------|-------------|
| `min_upper`   | Minimum uppercase letters |
| `min_lower`   | Minimum lowercase letters |
| `min_numeric` | Minimum digit characters |
| `min_special` | Minimum special characters |

**Rule:** `min_upper + min_lower + min_numeric + min_special <= length`

## Why It Matters
This constraint is easy to overlook when requirements grow over time. Keep a running total of all
`min_*` values when setting `length`.