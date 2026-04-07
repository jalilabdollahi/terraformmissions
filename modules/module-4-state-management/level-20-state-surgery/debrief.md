# State Surgery

## What Was Broken
Two problems existed simultaneously:
1. `resource "local_files" "config_b"` — `local_files` is not a valid provider resource type
2. The output referenced `local_files.config_b.filename`, also using the wrong type

## The Fix
```hcl
resource "local_file" "config_b" {
  content  = "config b"
  filename = "${path.module}/config_b.txt"
}

output "all_files" {
  value = [
    local_file.config_a.filename,
    local_file.config_b.filename,
    local_file.config_c.filename,
  ]
}
```

## State Recovery Strategy
When multiple resources fail, approach systematically:
1. `terraform validate` — catch type and syntax errors first
2. Fix validation errors
3. `terraform plan` — catch semantic and reference errors
4. Fix plan errors
5. `terraform apply` — apply and verify with `terraform state list`

## Why It Matters
Real-world state issues often involve multiple errors. The skill is identifying which errors
are root causes vs. cascading symptoms. In this case, fixing the resource type resolves both
the validation error and the output reference simultaneously.