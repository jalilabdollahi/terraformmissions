# Common Mistakes

- **Quoting numbers in maps** — `"8"` is a string, `8` is a number; provider attributes are type-strict.
- **Using count instead of for_each for maps** — count is index-based and causes cascade recreation.
- **Not validating variable types** — add `validation` blocks to enforce correct input ranges.
- **Large for_each with slow providers** — tune -parallelism down to avoid API rate-limit errors.