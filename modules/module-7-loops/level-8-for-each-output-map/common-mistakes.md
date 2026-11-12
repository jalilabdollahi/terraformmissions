# Common mistakes

- **Writing `local_file.ticket["night-ferry"].filename`.** It works for one film and hard-codes the
  key; the other two films vanish from the output.
- **Using a splat: `local_file.ticket[*].filename`.** Splat on a map-of-instances does not iterate the
  entries the way it does for `count`, and gives an unhelpful single-element result.
- **Replacing the output with `var.screenings`.** The values would be times, not ticket paths.
- **Forgetting `film =>` and producing a list.** Square brackets build a tuple, so the lookup by name
  disappears.
