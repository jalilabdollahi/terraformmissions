# Common mistakes

- **Moving only the modules and not the leftovers.** The flat resources, `random_integer.prototype_run` and the old `null_resource` stay behind and the plan still wants to destroy them.
- **Mapping `stall_loads[0]` to `h1`.** The old list was `h2, h1, h3`; the load ratings in `out/works-sheet.txt` show which index is which. A wrong mapping plans cleanly and silently swaps brass load ratings.
- **Moving the paint module but not the resource inside.** `module.paint` becomes `module.finishes`, but `random_integer.coat` is now `coat_grams`; without the second move both coats are recreated with new weights.
- **Deleting `prototype_run` from state with an ad-hoc command and forgetting the code.** It works once; the removed block documents the decision and covers every other environment.
- **Using `removed` without `destroy = false`.** The default destroys the object; the whole point is to forget it.
- **Bringing the null provider and `null_resource` back to make the plan quiet.** The oiling record has to become `terraform_data` through a moved block, which keeps its ID.
