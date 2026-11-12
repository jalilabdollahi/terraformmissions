# Common mistakes

- **Deleting `iterator = sheet`.** Then `source.value` works, but the mission keeps the explicit name; and
  the shadowing problem in the inner loop is still there, so the zip entries stay wrongly named.
- **Hard-coding the folder names.** The zip would look right for today's workshops but ignore anything added to
  `var.workshops`.
- **Fixing the names by changing the output path.** The folder names live inside the zip, not in its location.
- **Renaming the outer variable instead of the inner one.** Then `path` would use the list index of the
  panel loop for the folder and the workshop name for nothing; the rule is: inner loops need new names.
