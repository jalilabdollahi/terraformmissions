# Debrief - count turns a module into a list

Adding `count` to a module block changes its type. `module.snack_bar` is no longer one object with outputs; it is a
list of instances, with zero elements when the condition is false. Every reference to it must now decide
what to do when the list is empty. This is the same shape as `count = var.enabled ? 1 : 0` on a resource,
and the same reason `[0]` is dangerous: it works when open and fails when closed - and the failure only
appears the day somebody turns the feature off.

## The safe idioms

- **`one(module.x[*].out)`** - for a scalar. Returns the single element, or `null` for an empty list. It
  errors if there were more than one element, which documents the "at most one" assumption.
- **`try(module.x[0].out, null)`** - works too, but `try` also swallows genuine mistakes, such as a
  misspelled output name, so prefer `one()`.
- **`flatten(module.x[*].list_out)`** or `concat` - for list outputs; the empty case becomes `[]`.

## Consider the consumers

`null` and `[]` are different signals. Downstream code often reads them with `coalesce`, `try` or `length`;
decide on one convention for "feature disabled" and use it everywhere.

## Real-world takeaway

Optional modules (a bastion host, a monitoring stack, a snack bar) are common. Write the outputs for the
disabled case at the same time as the module, and test by planning with the flag off. The validator
applied the configuration open, closed, and open again with different items, to cover every direction of
the toggle.
