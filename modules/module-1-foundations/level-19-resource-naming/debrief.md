# The Name Game

## What Was Broken
`"1_config"` starts with a digit. HCL identifiers follow the same rule as most programming languages:
they must begin with a letter or underscore.

## Valid HCL Identifier Rules
- Start with: `a-z`, `A-Z`, or `_`
- Continue with: `a-z`, `A-Z`, `0-9`, `-`, or `_`
- Case-sensitive: `My_Resource` ≠ `my_resource`

## Naming Conventions
```hcl
resource "local_file" "app_config"     # snake_case (preferred by terraform fmt)
resource "local_file" "appConfig"      # camelCase (works but not idiomatic)
resource "local_file" "app-config"     # kebab-case (valid but less common)
```

Use `snake_case` — it's the community standard enforced by `terraform fmt`.