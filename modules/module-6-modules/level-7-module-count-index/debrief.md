# Debrief — count turns a module into a list

Adding `count` to a module call changes the *shape* of the name `module.post`. Without `count` it is one object
whose attributes are the outputs. With `count` it is a tuple of such objects, addressed by number, and addresses in
state gain an index: `module.post[0].terraform_data.lamp`. Every old reference such as `module.post.label` is now
invalid, which is why adding or removing `count` is a breaking change for callers.

Two idioms cover most needs. A splat, `module.post[*].label`, builds a list from one output across all instances and
quietly yields an empty list when the count is 0. An explicit index, `module.post[2].label`, selects exactly one
and fails when the instance does not exist, which is also what you want if the code truly depends on it.

Off-by-one errors are the other classic: `count` creates indexes `0 .. n-1`. If humans see the numbers, derive them
with `count.index + 1`; if you use the index to find a neighbour, remember the final element is
`length(module.post) - 1`.

Prefer `for_each` over `count` when instances have identities of their own (names, IDs), because removing the
middle element of a counted list renumbers every later instance. For plain "N identical things", `count` is fine.

**Takeaway:** `count` makes `module.x` a list, so collect with `[*]`, index with care, and number humans' labels from
`count.index + 1`.
