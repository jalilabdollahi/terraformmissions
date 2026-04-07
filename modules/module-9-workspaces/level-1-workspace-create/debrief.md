# Workspace Typo

## What Was Broken
`terraform.workpsace` is a misspelling of `terraform.workspace`. Terraform does not recognise
the misspelt attribute and raises a validation error.

## The Fix
```hcl
filename = "${path.module}/${terraform.workspace}.txt"
```

## terraform.workspace
`terraform.workspace` is a built-in expression that returns the name of the currently selected
workspace as a string. In the default workspace it returns `"default"`.

```bash
terraform workspace show   # prints current workspace name
```

## Use Cases
- Naming resources per environment: `"${var.name}-${terraform.workspace}"`
- Conditional logic: `terraform.workspace == "production" ? 2 : 1`
- Selecting environment-specific config from a map