# Debrief — three ways to fail to launch a program

The `external` data source does not run your script through a shell. It takes the `program` list,
treats the first element as the executable and starts it directly, with the remaining elements as
arguments. That keeps quoting predictable, but it means three independent things must be right,
and this mission broke each one in turn:

1. **The path must exist.** Relative paths are resolved from where Terraform runs, not from the
   `.tf` file, so build them with `path.module`. A folder rename in the repository silently turns
   into "no such file or directory" at the next plan.
2. **Direct execution needs the execute bit** (and a shebang line). A file copied from a zip, a
   Windows checkout or an artifact store often loses its mode. Either restore it with `chmod +x`
   (and make sure your version control records it; git keeps the executable bit) or sidestep the
   problem by naming the interpreter yourself.
3. **The interpreter must match the file.** Feeding bash syntax to Python produces an error that
   looks like a script bug when it is really a configuration bug.

Naming the interpreter (`["bash", path]`) is the most portable form: it works even if the file
mode is lost, and it documents what the script is. It also lets you keep scripts non-executable on
purpose. A caveat for teams: `python` may not exist on a machine where `python3` does (and the other
way round), so reference the exact interpreter name you tested with.
