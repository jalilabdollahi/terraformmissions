# Debrief — moved blocks make a refactor travel with the code

A resource's address is its identity in the state. Rename the block and Terraform sees an unknown
address (to create) and an orphaned state entry (to destroy). For a harness tag code or a database that is
a disaster.

A `moved` block fixes this declaratively: `from` is the old address, `to` the new one. During
planning Terraform rewrites the state entry in memory and shows `has moved to` instead of a
destroy/create pair. The state is updated for real on the next apply.

Why this beats `terraform state mv` in shared code:

- **Everyone gets the migration.** Anyone who pulls your branch and plans or applies, in any
  workspace or environment, gets the same move automatically. `state mv` has to be repeated by
  hand against every state.
- **It is reviewed.** The rename shows up in the pull request diff beside the code that needed it.
- **It is safe to repeat.** If the old address is not in a state, the block is simply ignored.

Keep moved blocks for as long as someone might still hold the old address, which for a public
module means indefinitely. For purely internal code you can delete them once every environment has
applied them. You can chain them (`a -> b`, `b -> c`) and also use them to move a resource into or out of a
module, or between `count` and `for_each` instances.
