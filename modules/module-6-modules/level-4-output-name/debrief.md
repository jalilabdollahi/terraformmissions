# Debrief — outputs are the only door out of a module

From the root, `module.cellar` is an object whose attributes are exactly the module's `output` blocks. Locals,
variables and resources inside the module are invisible; you cannot reach `module.cellar.local.batch_id` or
`module.cellar.local_file.tray_card`. This encapsulation is what lets a module author reorganise the inside
freely, as long as the outputs keep their names and types.

The error message is precise but easy to skim: "This object does not have an attribute named
`batch_code`". When you see it, do not guess at synonyms. Open the child module, read its `output` blocks and use
those names. In larger codebases the same check is `terraform console` followed by typing `module.cellar` — the
console prints the whole object with every available output and its current value.

Be careful with your instinct to "fix" the module instead. Renaming an output is a breaking change for every
caller, including ones in other repositories that you can't see from here. Adding an alias output is nicer,
but it leaves two names for one concept, and the confusion you cleaned up returns the next time somebody
extends the module.

**Takeaway:** a module's outputs are its public API. When a reference fails, change the caller to match the
API, using `terraform console` to inspect `module.<name>` if you are unsure what it exposes.
