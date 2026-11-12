# Solution guide

**Diagnose.** In the qa workspace `terraform plan` fails with an *Invalid index* error ("the given key does
not identify an element in this collection value"), pointing at `local.layouts[terraform.workspace]`. The
key is `"qa"` and the map holds only `dev` and `prod`.

**Fix.** Add an entry:

```hcl
qa = {
  stalls = 12
  hours  = "09-16"
  music  = false
}
```

`terraform plan` now works in qa, and dev and prod are unchanged.
