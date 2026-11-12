# Post-mortem - the Friday reindex

**Timeline.** Friday 16:40 PR #212 ("no more count") is merged. Monday 06:05 the pipeline plan shows 20 to add and 20 to
destroy. The change window was blocked before anything was applied.

**Root causes.**
1. The refactor renamed addresses without telling Terraform: state is keyed by address, so a new address is a new
   object and an old one is an orphan.
2. Nobody recorded that the old lists were ordered `C3, A1, B2, G7, ...`. With count, the index is an identity, and the
   identity lives in the order of a variable that someone had already re-sorted.
3. The plan was reviewed by looking at the diff of `.tf` files, not at the plan summary.

**What went right.** Nothing was applied; the manifest on disk preserved the name-to-value pairs, which is the only reason
the index mapping could be proved.

**How Terraform treats it.** `moved` blocks are processed during plan: the state entry is re-keyed first, then the
configuration is compared, so a correct set produces "has moved" lines and no changes. The block does not validate what you
map. Two random_integer objects with identical settings are interchangeable to Terraform, which means a swapped mapping
looks perfectly healthy and is only wrong in the real world.

**Prevention.**
- Ship `moved` blocks in the same PR as any rename or count-to-for_each change, and keep them for at least one release so
  every environment catches up.
- When converting count to for_each, derive the keys from data that already identifies the object, and capture the
  index-to-key table before merging.
- Gate pipelines on a "no destroy" check for refactor PRs.
