# Common mistakes

- **Writing `local_file.ticket["poets-night"].filename`.** It works for one event and hard-codes the
  key; the other two events vanish from the output.
- **Using a splat: `local_file.ticket[*].filename`.** Splat on a map-of-instances does not iterate the
  entries the way it does for `count`, and gives an unhelpful single-element result.
- **Replacing the output with `var.sessions`.** The values would be times, not ticket paths.
- **Forgetting `event =>` and producing a list.** Square brackets build a tuple, so the lookup by name
  disappears.
