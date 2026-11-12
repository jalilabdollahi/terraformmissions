# Common mistakes

- **Creating `studio/notes.txt` by hand.** The next fresh checkout fails again; the validator plans from a scratch copy with no `studio/` folder.
- **Wrapping `file()` in `try()` or `fileexists()`.** It makes plan pass but gives an empty or missing quote on the first run and a different
  result on the second, a perpetual diff.
- **Adding `depends_on = [local_file.session_notes]` to the locals.** `locals` cannot take `depends_on`, and it would not change when `file()` is evaluated anyway.
- **Switching to `data "local_file"`.** It can work with careful dependencies, but the mission is to use the value Terraform already has.
- **Running `terraform apply -target=local_file.session_notes` first.** It works once; the configuration is still broken for everyone else.
