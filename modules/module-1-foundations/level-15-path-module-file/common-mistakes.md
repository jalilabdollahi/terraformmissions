# Common mistakes

- **Prefixing with `./` (`file("./header.txt")`).** That is the same working-directory-relative lookup, and it
  still misses the `templates/` folder.
- **Using an absolute path.** `/Users/me/...` works on one machine only, and the validator rejects configs that
  do not go through `path.module`.
- **Moving the snippets next to main.tf.** Terraform finds them, but the task keeps them in `templates/`.
- **Pasting the snippet text into the config.** The letter looks right, but the snippets are meant to stay editable
  files; the validator checks for that.
