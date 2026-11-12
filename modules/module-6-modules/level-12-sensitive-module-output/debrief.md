# Debrief — sensitivity is contagious, and it must be declared

Terraform tracks sensitivity as a property of *values*. `random_password.result` is born sensitive, and anything
computed from it (a string interpolation, a module output, another module's input) inherits the mark. The mark
only affects display: the value is still stored in state in plain text and still flows to resources normally. That
is why `local_sensitive_file` happily wrote the code to disk.

Outputs are where the display rule bites. An output that carries a sensitive value must say so with
`sensitive = true`, otherwise Terraform stops: the check exists so nobody leaks a secret into a CI log just by
adding an output. In a module hierarchy the rule applies at *every* level. Terraform only *enforces* the declaration on root outputs, but a well-written module marks its own output
too: that is the only place its author can say "this is a secret" for every caller, present and future.

A sensitive output is hidden from `terraform output` and from plan and apply logs, but it is not encrypted.
`terraform output -raw door_code` prints it for scripts, and the state file contains it. Protect state like a
secret store: remote backend with encryption and tight access, never a repository. `nonsensitive()` exists for the
rare case where a value derived from a secret is truly public (a hash length, say). Using it to make an error
disappear defeats the safeguard.

**Takeaway:** secrets stay marked end to end: `sensitive = true` on the module output and on every root output that
forwards it, and treat the state file as the real secret.
