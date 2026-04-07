# Special Characters Gone Wrong

## What Was Broken
`override_special = ""` tells the provider to use an empty set of special characters. Combined
with `special = true`, this is a contradiction — the resource must include special characters
but has no characters to choose from.

## The Fix
Provide a non-empty string for `override_special`:

```hcl
override_special = "!@#$%"
```

Or remove `override_special` entirely to use the provider's default special character set.

## How `override_special` Works
- When **not set**: uses the provider's default set (`!@#$%^&*()_+-=[]{}|;':,./<>?`)
- When **set to a non-empty string**: restricts special chars to only the listed characters
- When **set to `""`**: produces an empty set — incompatible with `special = true`

## Why It Matters
The interaction between `special` and `override_special` is subtle. Understanding how provider
arguments interact helps you avoid confusing runtime errors.