# Common mistakes

- **Loosening the module's regex or range.** The error disappears for this caller and the guard disappears for every other
  one. The validator keeps the checks and tries `doors_open_hours=2`.
- **Hard-coding `"SOR-07"` in the call.** The default plan is green; changing the run number or the act is not.
- **Using `%d` instead of `%02d`.** The code becomes `SOR-7`, which the pattern rejects.
- **Forgetting `upper()`.** `sor-07` fails the capital-letter rule.
