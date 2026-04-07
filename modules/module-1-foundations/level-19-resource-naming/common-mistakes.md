# Common Mistakes

- **Starting with a digit** — prefix with a letter: `1_config` → `v1_config`.
- **Using reserved words** — don't name resources `self`, `each`, `count`, or `path`.
- **Using dots in names** — dots are not valid in resource names (they separate type.name in references).