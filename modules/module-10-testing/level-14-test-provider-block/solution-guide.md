# Walkthrough - Record Label Pressroom

1. `terraform test` stops with
   ```
   Error: Missing provider definition for local.vault
     on tests/pressroom.tftest.hcl line 22, in run "master_is_read_only":
   This provider block references a provider definition that does not exist.
   ```
2. Look at `terraform.tf`: `configuration_aliases = [local.press, local.vault]`. The module cannot configure those
   aliases itself; whoever uses it (here: the test file) must.
3. In `tests/pressroom.tftest.hcl` the provider blocks are `alias = "press"` and `alias = "archive"`. There is no
   `local.vault`, so the run's `providers = { local.vault = local.vault }` points at nothing. Rename `archive`
   to `vault`.
4. Runs that do not declare `providers` pick up test-file provider blocks by matching name and alias,
   so `sleeve_goes_to_press` and `catalog_number_flows` also rely on both blocks being correct.
5. `Success! 3 passed, 0 failed.`
