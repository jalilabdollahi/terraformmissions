# Debrief — the state is a database you can query

Terraform keeps a record of every object it has created: its address, its ID and all of its
attributes. Two read-only commands let you browse that record without touching real infrastructure:

- `terraform state list` shows every address, including `for_each` instances like
  `random_integer.serial["annex"]`.
- `terraform state show <address>` prints all attributes of one object, including values that no
  output or file ever exposed.

Both are safe: they read the state and change nothing. That makes them the first tools to reach for
when you need a fact such as an ID, an IP address or a generated name that Terraform created.

The same idea explains why state files are sensitive. Anything a provider returns, including
generated passwords and private keys, sits in the state in plain text unless the backend encrypts
it. The registry file in this mission hid the serials on purpose, yet a single command revealed them.
Treat read access to state as read access to secrets.

In daily work you will use `state list` to confirm a resource really exists after an import, to find
the exact address of a `for_each` instance before a `state mv` or a `-replace`, and to answer
"what does Terraform think it owns?" during an incident. When you need the value in a script, prefer
an `output` or `terraform show -json` with `jq`; `state show` is meant for humans.
