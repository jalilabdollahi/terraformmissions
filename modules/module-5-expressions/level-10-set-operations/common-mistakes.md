# Common mistakes

- **Using `distinct(concat(...))` for everyone.** The default case matches, but the output is a
  list in sheet order, not the sorted set the roll needs, and the check wants `setunion()`.
- **Swapping the `setsubtract()` arguments.** Elin, who is not singing, is listed and the three
  singers without robes are missing.
- **Typing the three results as literals.** The second sheet set in the check proves they are computed.
- **Indexing a set, e.g. `local.need_a_robe[0]`.** Sets have no positions; convert with `tolist()`.
- **Deduplicating the input variables by hand.** The sheets are meant to stay messy; the functions
  handle it.
