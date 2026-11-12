# Solution guide

1. `terraform validate` reports two errors:
   - on `terraform_data.clue_counter`: a warning, `Quoted references are deprecated`. `"local_file.clues"`
     is a string literal rather than a reference and works only for backwards compatibility;
   - on `local_file.title`: the error `Invalid depends_on reference`: entries must be a whole object
     (resource or module), not an attribute such as `.filename`.
2. Replace both with `depends_on = [local_file.clues]`.
3. `terraform apply`; `cat puzzle/clue-count.txt` shows `5`.
4. `terraform graph | grep clues` shows both edges.
