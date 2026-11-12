# Walkthrough - Closed Snack Bar

1. `terraform plan` fails on both outputs: *Unsupported attribute ... This value does not have any
   attributes* (`module.snack_bar` is a tuple because the module call has `count`).
2. Decide what each output should say when the module has zero instances:
   - a single value: `null` - use `one(module.snack_bar[*].menu_path)` (`one()` returns the only element
     of a 0- or 1-element list, or null);
   - a list: an empty list - use `flatten(module.snack_bar[*].items)`.
3. `module.snack_bar[0].menu_path` fixes the open case but errors with "Invalid index" when closed; try
   `terraform plan -var snack_bar_open=false` to see.
4. Apply both ways: open gives a path and items, closed gives `null` and `[]`.
