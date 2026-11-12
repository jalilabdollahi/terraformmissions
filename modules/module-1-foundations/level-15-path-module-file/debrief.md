# Debrief — Marta And Idris Invitations

**What broke.** `file("header.txt")` looks for `header.txt` relative to the process's *working directory*,
and the snippet lives in `templates/`. Even with the right subfolder, a bare relative path is fragile: it
changes meaning depending on where Terraform is run from, for instance with `terraform -chdir=...`, from a
CI job, or when the configuration is used as a child module.

**The path values.** Terraform gives you three anchors:
- `path.module`: the directory of the current module, usually what you want for files shipped with the code.
- `path.root`: the directory of the root module, useful for a shared top-level file.
- `path.cwd`: the directory where Terraform was started, which is almost never what you mean.

Combine them with `/` and a relative path, as in `"${path.module}/templates/header.txt"`.

**Why `file()` is special.** It is evaluated at plan time and only reads files that exist before apply. It cannot
read a file that another resource creates in the same run; for that, use the resource's own attribute (or the
`local_file` data source on a later run).

**Real-world takeaway.** Always use `path.module` when a module reads a file beside its code. It is what makes a
module reusable: callers can `module "x" { source = "../x" }` from any directory and the templates are still found.
