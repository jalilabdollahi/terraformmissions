# Common mistakes

- **Deleting the `version` lines.** `init` succeeds, but the config no longer pins anything, and the
  mission asks to keep a constraint on both providers.
- **Writing `">= 3.6"` for one provider and leaving `"~>= 2.5"` for the other.** `init` reports each
  invalid constraint; fix both.
- **Pinning to a version that is not installed (`"= 9.9.9"`).** The syntax is fine but no such release
  exists, so `init` fails with "no available releases match".
- **Using `terraform init -upgrade` to "refresh" the error away.** Nothing changes: the constraint
  string itself is invalid.
