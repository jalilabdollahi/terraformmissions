# Debrief — ordering is built from references

Terraform has no concept of "do this first". It builds a dependency graph from references between
blocks, and runs independent blocks in whatever order it likes. Typing the same path into two blocks
creates no edge in that graph, so the file-writing resource and the file-reading data source were
unrelated as far as Terraform knew.

That matters more for data sources than for resources, because of *when* they run. If all of a data
source's inputs are known and nothing it depends on has pending changes, Terraform reads it during
**plan** so the rest of the plan can use real values. Here that meant reading a file that did not
exist yet (a hard error), or, when an old copy existed, reading yesterday's content and planning
with a stale dose. The second symptom is the more dangerous one because nothing fails.

Referencing an attribute of the resource (`local_file.batch_sheet.filename`) is the preferred fix:
it states *why* the dependency exists. An explicit `depends_on` is the fallback when no attribute is
naturally involved, for example when something outside Terraform produces the data. Either way,
Terraform defers the read until apply, the same apply that writes the new sheet.

A good habit: if a data source reads something that the same configuration produces, ask whether you
need the data source at all. Often the value you are about to read back is already available as an
attribute or a local, and no round trip through the file system is needed.
