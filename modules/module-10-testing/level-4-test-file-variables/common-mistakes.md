# Common mistakes

- **Giving the variables defaults in `pairings.tf` instead.** That makes the mission's required inputs optional and hides the missing-value mistake from every real caller; the validator also checks the file-level block exists.
- **Copying the whole variables block into each run.** It works, but the shared block is the point; the second run should override only `players`.
- **Putting the block inside the first `run`.** It then applies to that run only, and `odd_roster_gets_bye` fails with `No value for required variable`.
- **Writing `variables = { ... }` with an equals sign and braces.** That is the exact original error.
