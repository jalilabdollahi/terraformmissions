# Echoo is Not a Command

## What Was Broken
`provisioner "local-exec"` runs a shell command on the machine where Terraform is executing.
`echoo` is not a valid shell command (it is a typo of `echo`), so the shell returns a non-zero
exit code, which Terraform treats as a provisioner failure.

## The Fix
```hcl
provisioner "local-exec" {
  command = "echo hello"
}
```

## How `local-exec` Works
- The command runs on the **Terraform runner's machine** — not a remote server
- A non-zero exit code causes the provisioner to **fail**
- Provisioner failures cause `terraform apply` to fail and mark the resource as **tainted**

## Important Notes on Provisioners
Provisioners are a **last resort** in Terraform:
1. Use native provider resources when possible
2. Use `user_data` / `cloud-init` scripts for cloud VM initialization
3. Use configuration management tools (Ansible, Chef, Puppet) for complex setups

## Why It Matters
Shell command typos are caught only at runtime, not at validate time. Always test provisioner
commands independently in a shell before embedding them in Terraform.