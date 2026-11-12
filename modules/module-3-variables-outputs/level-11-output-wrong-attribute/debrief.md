# Debrief — outputs can only read what a resource exports

A resource block has two kinds of attributes: **arguments** you set (`filename`, `content`) and
**exported attributes** computed by the provider (`id`, `content_sha256`, and so on). In expressions
you can read both, but only names that exist in the provider's schema. Anything else — `path`,
`sha256`, `name` — fails at validate time with "Unsupported attribute". That is good news: the typo
is caught before any infrastructure changes.

Common causes of this mistake:
- Using a name from a different provider's resource (AWS uses `arn`, `id`; `local_file` has none of
  those besides `id`).
- Remembering the attribute from a shell command or a resource's old version.
- Assuming a function's name (`sha256`) is also an attribute name.

Where to look: the provider documentation page for the resource (arguments reference vs attribute
reference), `terraform console` after an apply (`local_file.catalogue` prints the whole object), and
`terraform providers schema -json` for a machine-readable view.

Prefer the exported attribute over recomputing it: `content_sha256` is the checksum of exactly what
the provider wrote, whereas your own `sha256()` could disagree if you transform the content differently.

## Real-world takeaway

Whenever an output or reference doesn't work, run `terraform validate` first, then open
`terraform console` and print the resource. The object's keys are the ground truth.
