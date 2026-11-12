# Walkthrough - Dog Walk Dispatch Mock

1. `terraform test`:
   ```
   Error: Unsupported argument
     on tests/dispatch.tftest.hcl line 3, in mock_provider "random":
   An argument named "hex" is not expected here.
   ```
   `mock_resource` accepts `defaults` (and `override_during`), not the resource's attributes directly.
   Wrap it: `defaults = { hex = "ab12cd34" }`.
2. Re-run. The `dispatch_zone` assertion now fails and prints an actual value like `zone-5` or `zone-2`
   instead of `zone-4`. The mock for `random_integer` set a key called `value`, but the resource's attribute is
   `result`. Unknown keys in `defaults` are silently ignored, so the mock provider generated its own value.
3. Rename the key: `defaults = { result = 4 }`.
4. `terraform providers schema -json` (or the provider docs) lists the real attribute names if you are unsure.
5. `Success! 3 passed, 0 failed.`
