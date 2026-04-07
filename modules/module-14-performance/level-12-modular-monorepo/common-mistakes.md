# Common Mistakes

- **Using .id instead of .result** — always verify attribute names in provider documentation.
- **Not testing modules independently** — validate each module in isolation before composition.
- **Missing output declarations** — a module that doesn't declare an output cannot pass values to callers.
- **Circular module dependencies** — Terraform cannot resolve cycles; design the dependency graph as a DAG.