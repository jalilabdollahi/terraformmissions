# Common Mistakes

- **Asserting outputs that don't exist** — always verify the output name exists in `main.tf`.
- **Expecting isolated state per run** — runs share state; a resource created in run 1 still
  exists in run 2.
- **Forgetting that test state is ephemeral** — resources are destroyed after the test completes;
  do not rely on test-created files for subsequent `terraform apply` runs.