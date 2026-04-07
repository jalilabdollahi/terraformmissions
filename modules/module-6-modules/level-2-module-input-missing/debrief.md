# Missing Module Input

## What Was Broken
The child module declares `variable "app_name"` without a `default` value, making it **required**.
The root's `module` block did not supply a value for it.

## Required vs Optional Variables
```hcl
# Required — no default:
variable "app_name" {
  type = string
}

# Optional — has a default:
variable "app_name" {
  type    = string
  default = "app"
}
```

## The Fix
Pass the value from the root:
```hcl
module "myapp" {
  source   = "./modules/app"
  app_name = "myapp"   # required argument
}
```

## Concepts
- Child module variables without `default` are required.
- Root passes values as named arguments in the `module` block.