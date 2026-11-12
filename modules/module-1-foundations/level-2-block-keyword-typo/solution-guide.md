# Walkthrough — Hollow Ridge Bookings

1. **Run `terraform validate`.** You will see errors like:
   ```
   Error: Unsupported block type
     on main.tf line 2:
      2: varible "telescope" {
   Blocks of type "varible" are not expected here. Did you mean "variable"?
   ```
   and the same for `outputs` ("Did you mean "output"?").
2. **Fix each keyword.** The first word of a block is its *type*; it must be spelled exactly. Change
   `varible` to `variable` and `outputs` to `output` (singular).
3. **Re-run `terraform validate`**, then `terraform apply`. Terraform's "Did you mean" hint is
   usually right — trust it.
