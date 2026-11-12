# Debrief: depends_on takes resources, not text

Terraform normally works out ordering from references: if `b` uses `a.id`, `a` is created first. A
`depends_on` is for **hidden** dependencies, where the relationship exists only in the real world,
such as a shell command reading a file by path, as here. Its argument is a list of references to
whole resources or modules. Two classic mistakes, one a warning and one an error:

- quoting (`"local_file.clues"`): Terraform 0.11 required strings; modern versions only accept them
  with a deprecation warning ("Quoted references are deprecated") and will drop them, so write real
  references;
- attribute paths (`local_file.clues.filename`): depends_on is about the whole object. If you
  wanted to depend on a value, just use it in an expression, which creates an implicit dependency.

For the title file, note that the `depends_on` is actually unnecessary: nothing in it needs the clues
file. Keep `depends_on` for real hidden dependencies, since it also makes plans more conservative:
data sources that depend on a resource are deferred until apply. Prefer implicit dependencies by
referencing attributes where you can, e.g. `source = local_file.clues.filename`, and add a comment
whenever you do use depends_on to say what the invisible relationship is.
