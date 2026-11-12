# Common mistakes

- **Fixing the block keyword but leaving `locals.x` references.** Terraform now complains that `locals` is not a
  declared object; the prefix has to be the singular `local`.
- **Changing only the references to `local.x`.** Without the `locals {` block the names do not exist.
- **Using several `local { }` blocks.** The keyword is still wrong; plural `locals { }` blocks may repeat, but the
  singular form never works.
- **Leaving `wheel_price = 8 * 31`.** It evaluates to 248 today, but it is a copy of the other values; the mission
  wants it computed from them.
