# Common Mistakes

- **Setting `override_special = ""` with `special = true`** — empty override + special required is contradictory.
- **Including characters incompatible with your target system** — some systems reject certain special chars in passwords.
- **Forgetting that `override_special` has no effect when `special = false`** — enable `special = true` first.