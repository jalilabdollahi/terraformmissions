# Debrief — sensitivity is contagious, and it is not encryption

When a value is marked sensitive, Terraform tracks that mark through every expression that uses it.
A string template, a `merge()`, a `jsonencode()` — the result is sensitive too. If a *root module output*
carries a sensitive value and is not itself marked `sensitive = true`, Terraform stops with an error rather
than risk printing a password in a CI log. Requiring the explicit flag is a speed bump that forces the
author to decide.

What `sensitive = true` on an output does:
- The apply summary and the full `terraform output` listing show `<sensitive>` instead of the value.
- Asking for the output by name, or using `-json` / `-raw`, **still prints the value**, so scripts can use it.
- The value is stored **in plain text in the state file**. Marking something sensitive hides it from
  logs; it does not encrypt anything.

`nonsensitive()` exists for values that merely *look* sensitive (a hash, a derived non-secret length) —
using it here would defeat the purpose.

## Real-world takeaway

Treat the state file and remote state backend as secrets storage: encrypt at rest, restrict access.
Mark both inputs and derived outputs as sensitive so CI logs stay clean, and prefer passing secret
*references* (a secret manager path) over the secret itself when you can.
