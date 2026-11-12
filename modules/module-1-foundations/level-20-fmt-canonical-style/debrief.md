# Debrief — Kestrel Street Timetable

**What broke.** Nothing is wrong with the timetable logic; the repository fails a style gate. `terraform
fmt` rewrites configuration into the canonical style: two-space indentation, aligned equals signs for
consecutive single-line arguments, one space around operators and after commas, and so on. With
`-check` it only reports (exit code 3) which files differ, which is what makes it a good CI step.

**Why `-recursive` matters.** Without it, `terraform fmt` only looks at the current directory. Child
modules and subfolders, like `extras/` here, are skipped, and unformatted files hide there until the day
somebody runs the formatter in that folder and creates a noisy diff. The CI command should be
`terraform fmt -check -recursive`.

**Safe by design.** The formatter changes whitespace, never meaning, and the validator proves it by
applying and checking the generated files. It does not fix invalid syntax, reorder blocks, or rename
anything, so a file with a parse error still needs a human.

**Real-world takeaway.** Agree on canonical style once and let the tool enforce it: a pre-commit hook
(`terraform fmt`), a CI gate (`terraform fmt -check -recursive`), and an editor that formats on save mean
code reviews are about logic, not whitespace. Follow it with `terraform validate` in the same job, because
fmt does not check correctness.
