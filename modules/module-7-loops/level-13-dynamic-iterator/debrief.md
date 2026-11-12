# Debrief - the iterator names your loop variable

Every `dynamic` block gets a loop variable. By default it is named after the block label, so
`dynamic "source"` gives you `source.key` and `source.value`. That default is confusing when the label is
a generic noun, or when you nest dynamic blocks and two loop variables compete. The `iterator` argument
lets you choose a clear name: `iterator = class` means that inside `content { ... }` the current element is
`class`.

The catch is that the rename is exclusive. After `iterator = class`, the old name `source` does not
exist in that scope, and any leftover reference fails with "no variable named source". Here someone
renamed the iterator in one line and forgot the two lines that use it. It is a half-finished refactor,
the kind a compiler would flag in any language.

## Key and value

For a list, `class.key` is the zero-based index and `class.value` is the element. For a map it is the
map key and its value. Because each class here is an object, the useful parts are `class.value.file`
and `class.value.text`.

## Real-world takeaway

Use `iterator` when a dynamic block is nested inside another (`dynamic "rule"` inside `dynamic "policy"`),
or when the label is vague, and then use the chosen name consistently. The validator applied the config with
a different one-class list and checked the zip: a fix that only works for the defaults is a hard-coded
fix. It also checked that the same input gives the same checksum, which is a useful property of
`archive_file` output you can rely on.
