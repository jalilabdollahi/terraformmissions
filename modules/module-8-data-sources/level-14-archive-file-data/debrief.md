# Debrief — archive_file is a data source that writes a file

`data "archive_file"` looks like a lookup, but it does real work at plan time: it reads a directory,
builds a zip (or tar) and writes it to `output_path`. Everything about it follows from that.

**Paths matter immediately.** A wrong `source_dir` fails the plan, not the apply, because the archive
is built while the data source is read. `path.module` keeps the paths right wherever Terraform is
run from, and `output_path` should live outside `source_dir`; otherwise the archive would try to
include itself.

**The content is what you select.** By default every file below `source_dir` is included, drafts and
editor leftovers too. `excludes` takes a list of patterns relative to the source directory and is
the right place to keep temporary files out of an artifact. The validator opens the zip and checks the
member list rather than trusting the config.

**Digests come in flavours.** The data source exports `output_sha256` (hex, the format `shasum`
prints), `output_base64sha256` (the format AWS Lambda and many providers expect for
`source_code_hash`), plus md5, sha1 and sha512 variants. Mixing them up produces a value that looks
plausible and is simply never equal to what the other side computes. Before wiring a checksum into
anything, compute it independently once and compare.

Because the archive is rebuilt on every plan and is deterministic for unchanged input, a stable digest
doubles as a change detector: edit one label, and the hash, size and receipt all change on the next
apply. Resources that consume the zip (a function, an uploaded object) use the hash as their trigger
for redeployment.
