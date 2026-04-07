# Common Mistakes

- **Wrong key name** — JSON keys are case-sensitive. `App_Name` != `app_name`.
- **Nested key access** — use `local.parsed["outer"]["inner"]` for nested objects.
- **Array indexing** — use `local.parsed["items"][0]` to access the first element of a JSON array.
- **Not using `try()`** — if a key may not exist, wrap access in `try()` to provide a fallback.