# Common mistakes

- **Renaming the module's outputs to match the caller.** It turns a three-line fix into an interface change that every
  other caller would have to follow.
- **Adding alias outputs (`batch_code`) inside the module.** It silences the error but leaves two names for one thing.
- **Reading the resource directly: `module.cellar.local_file.tray_card.filename`.** Resources inside a module are
  private; only outputs are visible from outside.
- **Hard-coding `"SHI-W14"` in the root output.** The check with another species and week catches it.
