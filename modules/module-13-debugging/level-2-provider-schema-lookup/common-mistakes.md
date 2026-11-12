# Common mistakes

- **Deleting the failing argument.** `special` left out means special characters come back, and the card without
  `file_permission` is created world-readable.
- **Guessing synonyms** (`special_characters`, `mode`, `offset`) one at a time. Each `validate` round trip teaches you
  nothing; the schema lists every valid name at once.
- **Typing the audit date into the output.** The output must come from `time_offset` so it moves with `base_rfc3339`.
- **Using `override_special` to "remove" specials.** That only changes *which* special characters are allowed.
- **Reading the wrong provider's schema.** The output is keyed by provider address; make sure you are looking at
  `hashicorp/time`, not `hashicorp/null` or another one.
