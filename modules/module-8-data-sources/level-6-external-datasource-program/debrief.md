# Missing Executable

## What Was Broken
The `program` list referenced `nonexistent_binary`, which is not installed on the system.
Terraform tries to execute the program at plan time and fails immediately.

## The Fix
```hcl
data "external" "info" {
  program = ["python3", "-c", "import json; print(json.dumps({'key': 'value'}))"]
}
```

## Key Concepts
- The `program` list is passed directly to the OS exec syscall — no shell expansion occurs.
- The first element is the executable; subsequent elements are arguments.
- Use absolute paths (`/usr/bin/python3`) for reliability in CI/CD environments.
- The program must be present on the machine running `terraform plan` or `apply`.

## Common Alternatives
```hcl
# Shell script
program = ["/bin/bash", "${path.module}/get_data.sh"]

# Node.js
program = ["node", "${path.module}/get_data.js"]

# Python inline
program = ["python3", "-c", "import json,sys; print(json.dumps({'key':'val'}))"]
```