# Common Mistakes

- **Mismatched output key names** — the most common error when consuming remote state.
- **Forgetting to apply config-a before config-b** — config-b needs a real state file to read from.
- **Using relative paths in remote_state config** — paths are relative to the working directory at apply time.
- **Circular remote_state references** — config-a must never read config-b's state if config-b reads config-a.