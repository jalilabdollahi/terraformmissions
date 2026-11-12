# Common mistakes

- **Splitting the code without `moved` blocks.** The plan destroys `module.workshop.*` and creates
  new objects; the random batch ID changes and the box labels no longer match.
- **Letting `label` read the other modules' resources.** Module internals are not visible; pass the
  values as inputs and expose them as outputs.
- **Leaving `modules/workshop` in place "just in case".** The old module still declares resources
  that would be created again if anyone calls it.
- **Changing `path.root` to `path.module` in the moved resources.** The file name changes to the
  module directory, which replaces the file.
