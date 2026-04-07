# Common Mistakes

- **Using internal shorthand instead of actual output names** — always check the source config.
- **Renaming outputs without updating all consumers** — silent breakage in downstream teams.
- **Not documenting shared outputs** — consumers must guess names and frequently get them wrong.
- **Reading remote state before it exists** — always apply the producing config before the consuming config.