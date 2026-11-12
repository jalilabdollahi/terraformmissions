# Common mistakes

- **Using `random_string` instead of `random_password`.** It works, but the result is not sensitive and shows in plans and outputs.
- **Leaving the literal in a variable `default`.** The validator greps the whole configuration for the old passphrase.
- **Setting `special = true` without `override_special`.** Some characters break the `key=value` config format of the radio; the mission uses alphanumerics only.
- **Generating with `uuid()` or `timestamp()` in a local.** Those functions change on every plan, so the passphrase would rotate each apply.
