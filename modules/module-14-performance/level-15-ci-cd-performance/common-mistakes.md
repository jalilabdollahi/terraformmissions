# Common Mistakes

- **Not committing .terraform.lock.hcl** — causes version drift and slow CI runs on every pipeline execution.
- **Wrong provider source namespace** — `hashicorp-legacy`, `HashiCorp`, `HASHICORP` are all wrong.
- **Running terraform init without caching** — unnecessarily downloads providers on every CI run.
- **Not using plan files in CI** — allows a new commit between plan and apply to sneak in unexpected changes.
- **Forgetting -input=false in CI** — pipelines hang indefinitely waiting for stdin that never arrives.