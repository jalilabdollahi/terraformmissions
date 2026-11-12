# Debrief: triggers is map(string)

`null_resource.triggers` is declared as `map(string)`. Terraform converts simple types
automatically (number to string, bool to string), which is why `distance = 150` was fine, but it will
not flatten a list or object for you. You must choose the encoding:

- `join(",", list)` is compact and readable in plans, and suits plain lists of simple words;
- `jsonencode(value)` handles lists of objects and anything nested, and is unambiguous.

The reason `triggers` exists at all: a `null_resource` has no real infrastructure, so it only
changes when its trigger map changes. When any value differs from the one in state, Terraform
destroys and recreates the resource, which re-runs its provisioners. It is the classic "run this
again when X changes" hook. Nowadays the built-in `terraform_data` resource does the same with
`triggers_replace` and needs no provider, but `null_resource` is still everywhere in older code.

Real-world takeaway: pick triggers that represent the content (a joined list, a file hash via
`filemd5()`), not just a version number someone has to remember to bump.
