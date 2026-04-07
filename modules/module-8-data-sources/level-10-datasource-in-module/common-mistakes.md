# Common Mistakes

- **Case sensitivity** — `File_Content` != `file_content`.
- **Accessing internal resources directly** — you cannot do `module.reader.data.local_file.file.content`; you must use an output.
- **Forgetting to re-run `terraform init`** — after changing module source paths, always re-initialize.