# Debrief — data sources read early

A `resource` block describes something Terraform will create. A `data` block describes something
that already exists and that Terraform should *look up*. For `data "local_file"` the lookup is a
plain file read, and Terraform does it during `plan` (or even earlier, during validation of
references), as soon as the filename is known.

That timing is why this mission failed so loudly. A resource with a bad path would merely plan to
create a file somewhere odd; a data source with a bad path has nothing to read, so there is no value
to feed the rest of the graph, and the plan aborts with "no such file or directory".

Two habits make these errors rare:

- **Anchor paths with `path.module`.** It resolves relative to the directory holding the `.tf`
  file, so the config keeps working whichever directory you run Terraform from, and keeps working
  once the code is moved into a module.
- **Keep the lookup the source of truth.** The validator edited the sheet and re-applied; the card
  changed with it. If you had typed `56` into the config the plan would have passed once and then
  silently drifted the first time somebody re-voiced the stop.

In real projects the same pattern reads ssh public keys, license files, CSV exports from other
tools or rendered configuration from a previous pipeline stage. The first thing to check in any
"no such file" data-source error is the path as Terraform sees it, not the file you think you
wrote. Printing `${path.module}` in an output, or running `ls` from the module directory, settles it
in seconds.
