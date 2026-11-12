# Debrief — a module is its outputs

A module is a function with inputs (variables) and return values (outputs). Everything else, its
resources, locals and, as here, its data sources, is private. A data source inside a module is read
during the same plan as the rest of the configuration, but the parent can only see what the module
chooses to publish. Referencing `module.north_trail.snow_cm` is the same mistake as calling a
function result by a field it never returned.

The module author in this scenario made a sensible design choice: one object-valued output
(`reading`) instead of three scalar outputs. It keeps the interface small and lets the caller pass the
whole reading around, as `open_trails` does when it filters on `trail_open`. The cost is that callers
must navigate `module.<name>.<output>.<key>`.

Typical variations on this bug:

- the module output was renamed in a refactor and one caller was missed;
- the caller assumes an output exists because the module has a local or data source with a similar name;
- the module returns an object and the caller treats it as a string (or the other way round).

The cheapest defence is to give every module output a `description`, as this module does, and to read
the module's `outputs.tf` before using it. `terraform console` is also handy: evaluate
`module.north_trail` and Terraform prints the whole object, showing exactly which names exist.

One more note: the module reads a path handed in as a variable. Build such paths in the root with
`path.module`, so they do not depend on where the module's own directory happens to be.
