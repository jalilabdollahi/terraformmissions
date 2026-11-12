# Debrief — sensitivity is contagious, and keys are not secret

Terraform marks a value sensitive and then tracks that mark through every expression: `sha256()`, `upper()`,
`format()`, a `for` expression, a template string. If any input is sensitive, the result is sensitive. This is
deliberately conservative — Terraform cannot know that a hash is "safe enough" to show.

Two places refuse sensitive values outright. Outputs must be declared `sensitive = true` if they carry one
(otherwise the apply could print it). And `for_each` keys may not be sensitive, because instance keys are part
of the resource address that appears in plans, state and logs.

The design lesson is to model identity and secret separately. A list of names is public information; the token for
each name is not. Keeping them in two variables lets the public part drive the graph while the secret part is only
ever looked up at the point of use, where Terraform will still redact it.

Resist the reflex of reaching for `nonsensitive()` to silence an error like this. It does not make the data safe; it
only makes Terraform stop protecting it. A good rule: if you are about to unmask something, first ask whether the
value should have been split into a public half and a secret half.
