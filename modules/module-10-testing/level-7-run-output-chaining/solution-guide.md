# Walkthrough - Sailmaker Cutting Order

1. `terraform test` ends in:
   ```
   Error: Cycle:
     tests/sailloft.tftest.hcl.run.order_cloth
     tests/sailloft.tftest.hcl.run.measure_main
   Failure! 0 passed, 0 failed.
   ```
   `order_cloth` uses `run.measure_main...`, but `measure_main` is declared further down. Runs execute
   top to bottom; a reference to a later run can never be satisfied.
2. Reorder the file: `measure_main`, `order_cloth`, `spare_jib`.
3. Run again. Now `order_cloth` fails with `Unsupported attribute ... does not have an attribute named
   "area"`. The object `run.<name>` exposes that run's **outputs** by their real names; sailloft.tf
   defines `sail_area`. Use `run.measure_main.sail_area`.
4. `Success! 3 passed, 0 failed.` Use `terraform test -verbose` to see the values flowing through.
