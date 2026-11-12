# Walkthrough - Clock Repair Overrides

1. `terraform test` fails an assertion (`bench-3/turns-8` expected, a random ticket seen) and, further down,
   prints:
   ```
   Warning: Invalid override target
     on tests/ticket.tftest.hcl line 2, in override_resource:
   The override target random_integer.bench does not exist within the configuration under test.
   ```
   A wrong target is only a warning, so the test carries on with the real, random resource.
2. Compare with the code: the root resource is `random_integer.bench_slot`. Fix the first target.
3. The second warning names `random_integer.tension`. That resource is declared in
   `modules/mainspring/main.tf`, so its address from the root is `module.mainspring.random_integer.tension`.
4. Re-run; `ticket_default` and `ticket_reprinted` both pass and no warning appears.
   `Success! 2 passed, 0 failed.`
