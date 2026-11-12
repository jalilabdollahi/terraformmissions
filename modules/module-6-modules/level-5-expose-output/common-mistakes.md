# Common mistakes

- **Editing the root to read `local.next_call` or `module.crier.local_file.roster`.** Locals and resources inside a module
  are not reachable; only outputs are.
- **Typing `value = "15:00"` into the output.** It passes with the default hour and breaks the moment the hour changes.
- **Naming the outputs differently** (`next`, `file`). The root references are fixed by the mission, so the names must match.
- **Putting the `output` blocks in the root module.** They would refer to nothing the module has handed out.
