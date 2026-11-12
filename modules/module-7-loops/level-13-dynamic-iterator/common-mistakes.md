# Common mistakes

- **Deleting the `iterator` line.** It makes the errors disappear, but the mission asks to keep the
  readable name; the validator looks for `iterator = class`.
- **Renaming the block label to `class`.** The label has to stay `source`, because that is the nested
  block type of archive_file.
- **Using `class.file`.** The loop variable wraps the element; the attribute lives at `class.value.file`.
- **Replacing the dynamic block with three static `source` blocks.** It passes today but not the
  one-class run the validator makes.
