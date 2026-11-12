# Walkthrough - Colour Formula On Disk

1. `terraform test -verbose` shows `run "formula_file_written"... fail` and the assertion
   `fileexists(local_file.formula.filename)` reporting the file is missing, while the other two runs pass.
2. The cause is the `command` on that run. `command = plan` evaluates the configuration and builds a plan
   but creates nothing, so `salon/formula.txt` cannot exist. `command = apply` (the default when the line is
   omitted) really creates the file, runs the assertions, and the teardown at the end of the file destroys it.
3. Edit only that run:
   ```hcl
   run "formula_file_written" {
     command = apply
     ...
   ```
4. Re-run: `Success! 3 passed, 0 failed.`
5. Do not apply `command = apply` everywhere out of habit: the output-only runs are faster and safer as
   `plan`.
