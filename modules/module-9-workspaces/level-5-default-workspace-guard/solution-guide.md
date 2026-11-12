# Solution guide

**Diagnose.** In `default`, `terraform plan` prints `Warning: Check block assertion failed` and exits 0; apply
then writes `out/default-chimes.txt`. A `check` block is advisory: it reports, it never blocks.

**Fix.** Put the same assertion on the resource:

```hcl
resource "local_file" "chimes" {
  ...
  lifecycle {
    precondition {
      condition     = terraform.workspace != "default"
      error_message = "Refusing to schedule chimes from the default workspace. Select a tower workspace first."
    }
  }
}
```

A failed precondition is an *error* during plan, so nothing is created. `terraform workspace new tower-a` then
applies normally.
