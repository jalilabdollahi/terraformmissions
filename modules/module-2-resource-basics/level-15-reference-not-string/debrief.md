# Debrief: valid does not mean correct

This config is syntactically perfect, so `validate`, `plan` and `apply` all happily succeed. The
bug is semantic: a double-quoted string is a **literal**, and `"random_pet.table.id"` is simply
eighteen characters of text. Terraform has no way to know you meant a reference, because text that
looks like an address is still just text.

Rules of thumb for references:

- a bare reference is an expression: `value = random_pet.table.id`;
- inside a string use interpolation: `"table ${random_pet.table.id}"`;
- an expression that is only a single `"${...}"` is legal but redundant (old 0.11 style), and
  `terraform fmt` plus the linter will flag it;
- quoting also silently removes the dependency edge. A literal never creates a dependency, so
  `local_file` would not wait for the pet either, which is a second, quieter bug.

The only reliable defence is to look at what was actually produced. After an apply, open the file or
run `terraform output`; in CI, assert on the contents like the validator for this mission does. Plans
for these resources look right too: the `content` would show the literal text, which is easy to
skim past when you are expecting `(known after apply)`.
