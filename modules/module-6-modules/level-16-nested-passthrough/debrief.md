# Debrief — each module level is its own scope

A module only sees what its parent passes in. When the root calls `module.evaporator` with `season = var.season`, that
value becomes `var.season` *inside the evaporator*, and stops there. The evaporator's own call to `module.canner` starts a
fresh scope: the canner gets exactly the arguments written in that block, and nothing else, however many variables
the evaporator happens to have.

That is why a missing hop is dangerous when the variable at the bottom has a default. A required variable would turn the
mistake into an immediate "missing required argument" error. A defaulted one yields a plausible-looking result,
"season unknown" in a file nobody opens until the tins are on the shelf.

Outputs travel the opposite way and need the same discipline: the canner's `label` reaches the root only
because the evaporator re-exports it as its own `output "label"`. A hop that exists for variables must also exist for
outputs, one module at a time.

Defaults in deep modules are best kept for values that are really optional. Something that *every* caller must decide
(a season, a region, an environment name) is better left without a default, so a forgotten hop becomes a loud
failure at plan time. Tests help as well: assert that the final label contains the value you passed.

**Takeaway:** pass values down and outputs up explicitly at every nesting level, and avoid defaults that can mask a
missing hop.
