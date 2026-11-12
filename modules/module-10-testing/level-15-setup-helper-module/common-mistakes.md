# Common mistakes

- **Writing the manifest by hand into `tests/setup/manifest.json`.** The data source would read it, but the fixtures are no longer generated and cleanup is gone; the validator also checks that no manifest remains after the test.
- **Hard-coding `variables { manifest_path = "..." }` in the consumer runs.** It skips the chaining the mission asks for.
- **Giving `short_programme` its own `module` block.** That would test the helper module, not the cinema logic.
- **Forgetting `terraform init` after adding the module block.** Test module sources are recorded at init time.
