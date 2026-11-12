# Common mistakes

- **Fixing only the filename.** The content line and the output still print the raw text. All three spots
  need the fix.
- **Writing `"${"terraform.workspace"}"`.** Wrapping a literal in a template is still a literal.
- **Hard-coding `midsummer`.** It passes in the one workspace you tested, then every other harvest overwrites
  it. The validator tries a second workspace name.
- **Switching to a variable with a default.** `var.harvest` would not follow the workspace at all.
- **Forgetting the `$` in the content line.** `{terraform.workspace}` is not interpolation.
