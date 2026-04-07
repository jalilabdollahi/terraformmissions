# Common Mistakes

- **Using `.id` when `.filename` or another attribute is more appropriate** — check provider docs for attribute semantics.
- **Treating check failures as hard errors** — by default they are warnings.
- **Asserting on computed values that aren't stable** — avoid assertions on values that change each apply.