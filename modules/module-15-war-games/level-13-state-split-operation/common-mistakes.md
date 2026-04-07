# Common Mistakes

- **Removing resources from config without moved blocks** — results in destroy during the split.
- **Applying new config before updating old config** — creates duplicate resources.
- **Not backing up state files before state split** — one mistake and you've lost state.
- **Wrong order of operations** — always update the source config first, then the destination config.