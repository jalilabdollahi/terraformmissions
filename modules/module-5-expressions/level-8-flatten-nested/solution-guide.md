# Walkthrough — Roxy Showing Stubs

1. `terraform plan` fails on the `for_each` line with a message that the value has no attribute named
   `screen` (or that it is not an object).
2. Inspect the shape with `terraform console` after commenting the resource out, or experiment:
   ```
   > [for s, fs in {a=["x","y"], b=["z"]} : [for f in fs : {s=s, f=f}]]
   # [[{...},{...}], [{...}]]          <- a list of lists
   > flatten([for s, fs in {a=["x","y"], b=["z"]} : [for f in fs : {s=s, f=f}]])
   # [{...},{...},{...}]
   ```
3. Wrap the nested expression in `flatten([ ... ])` in `locals.showings`.
4. Apply. `terraform state list` should show six `local_file.stub["..."]` addresses. Run `check`.
