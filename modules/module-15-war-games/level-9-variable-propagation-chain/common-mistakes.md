# Common Mistakes

- **Renaming declaration but not call sites** — the variable declaration change is only half the work.
- **Missing intermediate module call sites** — in a 3-level chain, there are multiple call sites to update.
- **Not using grep to find all references** — manual search misses occurrences in complex codebases.
- **Renaming only in one module level** — verify the rename is complete end-to-end with a full plan.