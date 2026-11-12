# Common mistakes

- **Deleting the `iterator` line.** It makes the errors disappear, but the mission asks to keep the
  readable name; the validator looks for `iterator = lesson`.
- **Renaming the block label to `lesson`.** The label has to stay `source`, because that is the nested
  block type of archive_file.
- **Using `lesson.file`.** The loop variable wraps the element; the attribute lives at `lesson.value.file`.
- **Replacing the dynamic block with three static `source` blocks.** It passes today but not the
  one-lesson run the validator makes.
