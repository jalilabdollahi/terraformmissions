# Common Mistakes

- **Unquoted string keys** — `[primary]` is not valid; string keys always need quotes `["primary"]`.
- **Confusing count index with for_each key** — `[0]` is a count index; `["primary"]` is a for_each key.
- **Wrong key value** — the `to` key must exactly match the `for_each` key in the new config.