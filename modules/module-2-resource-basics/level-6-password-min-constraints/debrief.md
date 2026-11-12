# Debrief: minimums are reservations

`random_password` (and `random_string`) treat each `min_upper`, `min_lower`, `min_numeric` and
`min_special` as a number of positions that must be filled from that class. The generator first
reserves those positions and fills the remainder from the combined alphabet, then shuffles. If the
reservations alone are longer than `length`, there is no valid password, so the provider refuses at
plan time instead of silently weakening the policy.

Two takeaways. First, treat the policy as arithmetic: the sum of the minimums must be at most the
length, and the leftover positions are your entropy. A 12 character password with 11 reserved slots
has little randomness left in the composition, so when you can, raise `length` rather than lowering
every minimum. Second, `random_password` differs from `random_string` only in one way that matters:
its result is marked sensitive, so it is hidden in plan output. It is still written in clear text to
the state file, and anything derived from it (here the day-pass voucher file) must stay sensitive as well,
which is why the voucher uses `local_sensitive_file`.

If a downstream system rejects generated passwords, check the vendor's rules once and write them
next to the resource, as this config's comment does.
