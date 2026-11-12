# Debrief: modules have addresses too

Resource addresses are built from the path of module calls that contain them:
`module.north_shaft.random_id.tag`. Rename the module block and that path changes for every object
inside, even though the module's source and inputs are identical. Terraform sees objects in state
whose addresses are no longer declared, and objects in configuration with no state, and responds
with a destroy and create for each.

A `moved` block can describe the rename at the module level: `from = module.shaft_a`,
`to = module.north_shaft`. Terraform applies the same prefix rewrite to everything under it,
nested modules included, so one block covers a module with fifty resources. It also works for
`for_each` and `count` module instances, as long as you include the key, as in
`module.shaft["a"]`.

Compare this with the earlier levels where one resource changes name or moves into a module. The
module-level form is the one to reach for when a team standardises naming across a dozen module calls.
It is also easier to review: one block, one line of intent.

Real-world takeaway: renaming a module call is never cosmetic. Add the moved block in the same commit
as the rename, keep it until all environments have applied it, and check that the plan lists
`has moved to` rather than `will be destroyed`.
