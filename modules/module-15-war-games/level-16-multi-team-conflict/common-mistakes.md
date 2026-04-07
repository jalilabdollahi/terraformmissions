# Common Mistakes

- **Each team using their own naming convention** — leads to mismatched output key references.
- **No cross-team communication about output changes** — teams discover breakage in CI, not review.
- **Not having an interface module** — forces each consumer to know team1's internal naming.
- **Renaming outputs without deprecation** — immediate breakage for all consuming teams.