# Common mistakes

- **Switching both calls to `concat()`.** `concat()` rejects maps, so the label breaks instead.
- **Fixing the allergens and leaving the label merge order alone.** The plan is green, but the
  label says grade OP and pack 50g tin; only the file content reveals it.
- **Using `setunion()` for the allergens.** It deduplicates but returns a sorted set, so the house
  warnings no longer come first.
- **Dropping `distinct()`.** sesame is printed twice on the label.
- **Writing the final map by hand.** Only the defaults match; other blends are not layered.
