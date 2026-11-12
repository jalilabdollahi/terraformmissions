# Debrief — defaults are constants; derived values are locals

When Terraform loads a module it first resolves the input variables, then evaluates locals, then
resources and outputs. A variable's `default` is part of the first step, so there is nothing yet to
reference: `var.brewery` has not been decided, because the caller may still override it. Terraform
therefore forbids references in defaults with `Variables may not be used here`.

The intent in this configuration is a perfectly reasonable one: "unless somebody says otherwise, the
label is derived from the brewery". Express that in two layers:

1. an **input** (`batch_label`) whose default is `null`, meaning "not provided";
2. a **local** that computes the effective value with `coalesce(var.batch_label, ...)`,
   or `var.batch_label != null ? var.batch_label : "..."`.

Everything downstream uses the local. This pattern gives you a single place where the rule lives, keeps the
override possible, and makes the effective value easy to read in `terraform console` (`local.batch_label`).

Note that `nullable` defaults to true for variables, so `null` is accepted. `coalesce` skips both `null`
and the empty string, so an empty-string override also falls back to the derived default, which is
usually what you want.

## Real-world takeaway

Whenever you reach for "default = something computed", you want a local. Reserve defaults for true
constants. The same reasoning explains why `count`/`for_each` values cannot be set from defaults of
attributes that are only known after apply.
