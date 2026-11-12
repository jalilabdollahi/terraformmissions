# Common mistakes

- **Moving only the modules and not the leftovers.** The flat resources, `random_integer.trial_batch` and the old `null_resource` stay behind and the plan still wants to destroy them.
- **Mapping `room_shelves[0]` to `r1`.** The old list was `r2, r1, r3`; the capacities in `out/dairy-sheet.txt` show which index is which. A wrong mapping plans cleanly and silently swaps tank capacities.
- **Moving the rennet module but not the resource inside.** `module.rennet` becomes `module.cultures`, but `random_integer.strain` is now `strain_grams`; without the second move both strains are recreated with new weights.
- **Deleting `trial_batch` from state with an ad-hoc command and forgetting the code.** It works once; the removed block documents the decision and covers every other environment.
- **Using `removed` without `destroy = false`.** The default destroys the object; the whole point is to forget it.
- **Bringing the null provider and `null_resource` back to make the plan quiet.** The CIP record has to become `terraform_data` through a moved block, which keeps its ID.
