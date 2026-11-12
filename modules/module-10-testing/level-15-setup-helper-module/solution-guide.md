# Walkthrough - Comedy Club Lineup Setup

1. `terraform test` fails in `run "setup"`: `No value for required variable lineup_path`. The run has no
   `module` block, so it executes the root configuration (the club logic) which needs that input.
2. Add the module block to the first helper:
   ```hcl
   run "setup" {
     module {
       source = "./tests/setup"
     }
   }
   ```
   Run `terraform init`, then `terraform test`.
3. `short_show` passes. Now `double_header` fails its assertion (`200 minutes must trigger an intermission`).
   Its helper `setup_long` runs with `command = plan`, so the new 200-minute lineup is planned but never
   written, and the consumer reads the stale 105-minute lineup left by the first helper. (With no earlier
   fixture you would see `Read local file data source error ... no such file`.) A helper that must leave
   something behind has to be an apply run.
4. Change `setup_long` to `command = apply`.
5. `Success! 4 passed, 0 failed.` After the run Terraform destroys the helper resources in reverse order,
   so no `lineup.json` remains in `tests/setup`.
