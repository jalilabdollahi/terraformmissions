# Walkthrough - Studio Notes Not Found

1. `terraform plan` fails on the `locals` block with `Invalid function argument ... no file exists at ./studio/notes.txt`.
2. Confirm the timing: `ls studio` (nothing). The only thing that will write that path is `local_file.session_notes`, and
   resources are created at *apply* time.
3. `file()` is evaluated during plan, in the middle of building the graph, so it cannot see files created by the same run. (It
   would work on a second run, which is exactly the "works on my machine" trap.)
4. Terraform already holds the text: `local_file.session_notes.content`. Use that in `notes_text`. A resource reference also
   adds the dependency, so the notes are written before the track sheet.
5. `terraform apply` on a fresh checkout works. `check`.
