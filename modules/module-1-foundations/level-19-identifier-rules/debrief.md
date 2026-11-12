# Debrief — Brightwell Filament Shelf

**What broke.** Names of variables, resources, locals and outputs are *identifiers*, and HCL gives them
strict rules: start with a letter or underscore, then letters, digits, underscores and hyphens. A space
splits a name into two labels, a leading digit looks like a number, and a dot is the attribute-access operator, so
`local_file.spool.tag.filename` would read as "attribute `tag` of `spool`", not as a resource called
`spool.tag`.

**Why the rules exist.** Every identifier has to be usable inside an expression such as
`local_file.label_3d.filename` with no quoting. If any character could appear in a name, the parser could not
tell where the name ends.

**Renaming has ripple effects.** The declaration is only one place; each reference must change too. Editors
with Terraform language support can rename symbols across files. In an existing deployment, renaming a
*resource* also changes its state address, which is a separate problem (see the `moved` block), but for a fresh
configuration like this one, a rename is free.

**Style.** The community convention is `snake_case` for everything, with descriptive but short names, no type
repeated in the name (`local_file.label`, not `local_file.label_file`) and `this` or `main` for the only instance of a type in a module.

**Real-world takeaway.** Choose identifier names the way you would for variables in code: lowercase, underscores,
no spaces or dots. Keep human-friendly wording for descriptions and tags, where any character is allowed.
