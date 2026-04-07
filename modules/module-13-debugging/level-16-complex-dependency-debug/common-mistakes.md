# Common Mistakes

- **Accidentally deleting a resource that others depend on** — always search for references before removing a resource.
- **Missing resource in a module** — if a resource was moved to a module, the root config needs to access it via module outputs.
- **Confusing `depends_on` with data references** — attribute references create implicit dependencies; `depends_on` is for non-attributional dependencies.