# Debrief — decompose behind a stable state

A module that does three jobs forces every consumer to take all three. Splitting it into small,
composable modules gives callers choice: wholesale uses `pour` only, refills use `pour` and `label`.
The price is that Terraform identifies objects by full address, so moving a resource into another
module is, to Terraform, "delete this, create that" unless you tell it otherwise.

`moved` blocks are that statement. They are code, so they are reviewed, and every environment that
applies the config performs the same migration, including the ones you will never touch by hand.
Keep them in the config at least until all environments have applied, then they can be removed (or
kept as documentation).

Good split boundaries:

- Resources that change together stay together (the pour sheet and its batch ID).
- Dependencies between the pieces become explicit module inputs and outputs. The label module takes
  `batch_code` instead of reaching into `random_id.batch`, which also makes it testable on its own.
- Do not let child modules call each other; composition happens in the root, so each piece stays
  independent.
- File paths that depend on `path.module` change when code moves; using `path.root` (or a variable)
  keeps the real object stable.

Real-world takeaway: refactor modules in two steps, restructure + `moved`, check the plan shows
moves and no deletes, then apply. A plan with "destroy" in a pure refactor is a stop sign.
