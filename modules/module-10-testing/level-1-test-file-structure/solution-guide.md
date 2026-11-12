# Walkthrough - Toll Plaza Fare Table

1. **Run the suite.** `terraform test`
   ```
   Error: Extraneous label for test
     on tests/fares.tftest.hcl line 1, in test "single_axle":
   No labels are expected for test blocks.
   ```
   `test {}` is a real top-level block (it holds test-wide settings such as `parallel`), but it takes
   no label. A named scenario is a `run` block.
2. **Rename the block type.** Change each `test "single_axle" {` to `run "single_axle" {` (and the
   other two). Keep the `assert` blocks and the `command = plan` line.
3. **Re-run.** `terraform test -verbose` should print three `run "..."... pass` lines and
   `Success! 3 passed, 0 failed.`
4. **If an assertion now fails**, read the `Diff:` section - but here the formula is right, so all
   three should pass.
