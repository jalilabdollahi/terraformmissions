# Walkthrough — Kestrel Street Timetable

1. **See the failures.**
   ```bash
   terraform fmt -check -recursive
   # main.tf
   # stops.tf
   # extras/depot-notes.tf
   ```
   `-check` lists files that would change and exits with status 3; it modifies nothing.
2. **Let the tool fix it.** `terraform fmt -recursive` rewrites the files in place: indentation to two spaces, tab
   to spaces, aligned `=` signs inside a block, spaces after commas.
3. **Re-check.** `terraform fmt -check -recursive` prints nothing and exits 0. The `extras/` file is only reached
   because of `-recursive`; without it, the CI job would only look at the root directory.
4. **Run `terraform apply`.** Formatting must not change behaviour.
