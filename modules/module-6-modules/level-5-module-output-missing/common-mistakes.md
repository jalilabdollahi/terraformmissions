# Common Mistakes

- **Trying to access `module.mymod.local_file.greeting.filename`** — you cannot reach into a child's resources directly.
- **Adding the output to the wrong file** — the output must be in the child module directory, not the root.