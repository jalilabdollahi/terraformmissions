# Common mistakes

- **Mapping "enabled" to false by reflex.** The syntax passes, but the voucher then has the wrong
  character classes; map each word by what the comment says the printer needs.
- **Quoting the booleans as `"true"` / `"false"`.** Terraform converts those, but it is poor style, and
  it hides the lesson: use bare words.
- **Deleting the lines that fail.** Defaults are `true` for all four classes, so lowercase letters and
  symbols come back.
- **Fixing one argument at a time and stopping early.** Terraform reports them one by one; run validate until it is quiet.
