# Common mistakes

- **Changing `ignore_changes = all` to `ignore_changes = [content]`.** Better scoped, but it still hides the very argument that carries the rules.
- **Editing `gate/access-rules.json` by hand to match the code.** The file looks right, but the next edit to the rules is invisible again — the validator probes exactly that.
- **Running `terraform apply -replace=local_file.gate_rules` and leaving the lifecycle block.** Replacement works with `ignore_changes`, which tricks you into thinking the problem is solved.
- **Deleting the `local_file` and recreating it under a new name.** This fixes today's file but leaves the masking pattern in your codebase.
