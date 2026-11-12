# Common mistakes

- **Copying the library into each component.** Three copies drift apart; call the one shared module via
  `../../modules/signal_sheet`.
- **Keeping `main.tf` in the root "for convenience".** The root would still own resources in a shared
  state, defeating the split; the root must be empty.
- **Using `path.root` for `out_dir` in the component.** When the component is the root this works, but
  `path.module` keeps the output next to the component whichever way it is called.
- **Referencing one component's module from another.** Components must be independent; share values
  through outputs, not through direct module calls.
- **Forgetting `terraform.tf` in a component.** Without `required_providers` the component cannot
  resolve the local provider on its own.
