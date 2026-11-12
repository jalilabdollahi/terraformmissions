# Debrief: a filename is a path, not a label

`local_file.filename` is an ordinary path. Terraform resolves it relative to the directory you run
it in, and `path.module` expands to the directory that holds the current module's `.tf` files. Writing
`"${path.module}/out/shift-board.txt"` anchors the file to the project instead of to wherever someone
happened to start their shell.

Two details worth remembering. First, `filename` is a "force new" argument: change it and Terraform
destroys the old file and creates the new one, so the stray copy in the root cleaned itself up. Second,
the `local` provider creates missing parent directories for you (`directory_permission` controls their
mode), so you never need a separate `mkdir` step.

In real projects this matters because generated artifacts (rendered configs, kubeconfigs, reports)
are consumed by other tools. If the output location is a convention, encode it once in a local such as
`output_dir = "${path.module}/out"` and build every filename from it. That way a mistake like this one
cannot happen in only one of three resources. Also add `out/` to `.gitignore`: generated files belong
next to the code, not inside version control.
