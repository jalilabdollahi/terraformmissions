# Debrief — what is inside a state file

A state file is plain JSON, and `terraform state pull` prints the current state from *whatever
backend is configured*, whether that is a local file, S3 or a remote service. That makes it the
one portable way to read state in a script.

Three top-level fields matter for operations:

- **`serial`** is a counter that increases every time the state changes. Terraform refuses to
  `state push` an older serial over a newer one, which protects you from overwriting recent work.
- **`lineage`** is a UUID created when the state was first initialised. It identifies the history
  the state belongs to. If a state's lineage differs from the one you expect, someone created a
  fresh state, and pushing it over the old one would orphan every resource.
- **`resources`** holds each object with its provider and its full `attributes` map.

Serial plus lineage is how you answer "is this the same state I looked at yesterday?" and why
backends can detect conflicting writers.

`jq` is the right companion: `jq -r` for raw strings, `select()` to filter resources and
`.instances[0].attributes` for values. Remember that this JSON also contains secrets such as
passwords and private keys in plain text. Never paste a raw `state pull` into a ticket or a chat; extract
only the fields you need.
