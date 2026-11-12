# Debrief — secrets from disk need the sensitive flavour

Terraform can only hide what it knows is secret. Values become *sensitive* when they come from a
variable declared `sensitive = true`, from a provider attribute the schema marks sensitive, or from
a function such as `sensitive()`. `data "local_file"` reads a file and exposes `content` as an
ordinary string, so a combination read through it is printed in plans, applies and outputs. Its
sibling `data "local_sensitive_file"` is identical except that `content` is flagged sensitive, and
the flag then follows the value through locals, expressions and into resource arguments.

Three consequences from this mission:

- **Propagation is automatic and viral.** The door card's `content` is derived from the sensitive
  data, so plan output shows `(sensitive value)`. An output that carries it must say
  `sensitive = true`; Terraform refuses to guess whether you meant to expose it.
- **Sensitive is display masking, not encryption.** The value is still stored in plain text in the
  state file (and plan files), and `terraform output -raw combination` prints it on request. Protect
  the state with encrypted remote storage and access control, and do not commit it.
- **Files have permissions too.** A secret written to disk should not be world readable. The card
  was created with `0644`; `file_permission = "0600"` limits it to its owner. (For files that
  are secrets from the start, `local_sensitive_file` also exists as a resource and masks the content in
  plans.)

Where you can, avoid having Terraform read secrets at all: reference a secrets manager so the
value never lives in a local file. When a local file is unavoidable, use the sensitive data source.
