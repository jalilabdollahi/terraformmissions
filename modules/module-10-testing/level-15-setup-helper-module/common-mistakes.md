# Common mistakes

- **Writing the lineup by hand into `tests/setup/lineup.json`.** The data source would read it, but the fixtures are no longer generated and cleanup is gone; the validator also checks that no lineup remains after the test.
- **Hard-coding `variables { lineup_path = "..." }` in the consumer runs.** It skips the chaining the mission asks for.
- **Giving `short_show` its own `module` block.** That would test the helper module, not the club logic.
- **Forgetting `terraform init` after adding the module block.** Test module sources are recorded at init time.
