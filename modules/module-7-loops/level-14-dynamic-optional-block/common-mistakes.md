# Common mistakes

- **Replacing null with an empty string: `content = coalesce(var.transcript, "")`.** The plan passes, but
  the zip contains an empty transcript file for every pack - not what the mission wants.
- **Making only `content` dynamic or conditional.** Arguments cannot be omitted inside a block that
  always exists.
- **Using `count` on the archive.** `count` would drop the whole zip instead of one entry.
- **Giving the variable a non-null default.** The mission is to support the unset case, and the
  validator also applies with the default.
