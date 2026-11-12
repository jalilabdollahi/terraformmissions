# Solution guide

1. `terraform validate` reports two errors:
   - on `terraform_data.page_counter`: a warning, `Quoted references are deprecated`. `"local_file.chapters"`
     is a string literal rather than a reference and works only for backwards compatibility;
   - on `local_file.cover`: the error `Invalid depends_on reference`: entries must be a whole object
     (resource or module), not an attribute such as `.filename`.
2. Replace both with `depends_on = [local_file.chapters]`.
3. `terraform apply`; `cat book/chapter-count.txt` shows `5`.
4. `terraform graph | grep chapters` shows both edges.
