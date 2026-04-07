# Common Mistakes

- **Designing modules that are too tightly coupled** — if A needs B and B needs A, they should be one module.
- **Not visualizing the dependency graph before writing modules** — draw the DAG on paper first.
- **Trying to work around cycles with depends_on** — depends_on cannot break data-dependency cycles.
- **Deeply nested module chains** — the deeper the nesting, the harder it is to avoid cycles.