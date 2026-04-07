# for_each Key Unknown at Plan Time

## What Was Broken
`random_string.result` is generated during apply, not during planning.
Terraform cannot build the resource graph without knowing `for_each` keys at plan time.

## The Rule
`for_each` keys must be **known at plan time** — they define the resource addresses.
Resource *values* (body attributes) can use computed values.

## The Fix
Use static keys, move computed values into the resource body:
```hcl
resource "local_file" "config" {
  for_each = toset(["main"])               # static key
  content  = "config for ${random_string.id.result}"  # computed value OK here
  filename = "${path.module}/config-${each.key}.txt"
}
```

## What CAN Be Unknown at Plan Time
- Resource body arguments (`content`, `filename`, etc.)
- Non-key references in `for` expressions used in outputs

## Concepts
- `for_each` keys determine resource identity — must be plan-time known
- Computed values are fine in resource arguments, just not as `for_each` keys