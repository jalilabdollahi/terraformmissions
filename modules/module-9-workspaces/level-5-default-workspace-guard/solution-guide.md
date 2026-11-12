# Solution guide

**Diagnose.** In `default`, `terraform plan` prints `Warning: Check block assertion failed` and exits 0; apply
then writes `out/default-sprays.txt`. A `check` block is advisory: it reports, it never blocks.

**Fix.** Put the same assertion on the resource:

```hcl
resource "local_file" "sprays" {
  ...
  lifecycle {
    precondition {
      condition     = terraform.workspace != "default"
      error_message = "Refusing to schedule sprays from the default workspace. Select a fountain workspace first."
    }
  }
}
```

A failed precondition is an *error* during plan, so nothing is created. `terraform workspace new fountain-a` then
applies normally.
