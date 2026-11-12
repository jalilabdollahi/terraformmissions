# Common mistakes

- **Applying right away.** Terraform destroys three mascots and invents three new ones: the hulls'
  paint is wrong. Always read the plan first.
- **Mapping in the wrong order.** `[0]` to `"benno"` plans cleanly but swaps the mascots between pedalos.
  Follow the original list order.
- **Running `terraform state mv` instead.** The state is fixed locally, but the mission asks for `moved`
  blocks, which travel with the code and the validator looks for them.
- **Reverting to `count`.** It makes the plan clean but undoes the refactor the team wanted.
- **Deleting the mascots from state with `state rm`.** Terraform would create new ones - the IDs change.
