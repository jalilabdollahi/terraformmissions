# Common Mistakes

- **Wrong path** — relative paths are resolved from the Terraform working directory, not the config file.
- **State file not initialized** — the source state file must exist before the consumer can plan.
- **Circular dependencies** — avoid having two stacks read each other's remote state.
- **Output not exposed** — the source stack must have `output` blocks for values you want to consume.