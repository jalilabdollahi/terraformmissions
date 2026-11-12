# Debrief — a template and its variables are a contract

`templatefile(path, vars)` reads a file, treats `${...}` and `%{...}` as template syntax, and renders
it with exactly the names you supply in the `vars` map. Nothing else is in scope: not your input
variables, not locals, not resource attributes. That isolation is what makes templates reusable, and
it is also why renaming a variable in one place breaks the other.

The rules in short:

- **Every placeholder needs a key.** A missing one is an error that quotes the line in the template.
- **Extra keys are ignored.** Passing more than the template uses is fine.
- **Expressions work inside placeholders.** The form uses `upper(station)` and
  `length(split(" ", body))`; all built-in functions are available.
- **Types carry through.** A list passed in can be looped over with `%{ for }`, which the module's
  last level explores.

Because the error appears at plan time and shows both the file and line, this class of bug is cheap to
fix. The expensive version is the reverse: a template that is shared by several modules, where one
caller still passes the old key names. Keep the list of variables a template expects in a comment at
the top of the template or in the module's documentation.

## Real-world takeaway

User-data scripts, cloud-init files, nginx configs and policy documents are classic templatefile
jobs. Treat the vars map as the template's API: name keys after the placeholders, keep both in review
together, and render the template with a second set of values in a test to prove nothing is hard-coded.
