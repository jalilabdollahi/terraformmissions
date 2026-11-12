# Common mistakes

- **Replacing the dynamic block with three static `source` blocks.** The zip is right today, but the
  mission asks for entries generated from var.documents, which the validator re-plans with new content.
- **Adding `iterator = source` and keeping the label `files`.** The iterator name is cosmetic; the label
  still names a block type archive_file does not have.
- **Renaming the label but not `files.key` / `files.value`.** The default iterator follows the label,
  so you get "unknown variable files".
- **Using `source_dir` pointing at a folder of files.** That produces a zip of files on disk, not of the
  map in the variable.
