# Debrief — nonsensitive() is a scalpel, not an eraser

`sensitive = true` is Terraform's guard rail: values carrying the mark are redacted in CLI output, and any expression
built from them inherits the mark. `nonsensitive()` exists for the rare situation where you can prove that a derived
value no longer reveals the secret — the number of characters in a code, whether a token is set at all, a boolean
computed from a comparison.

The anti-pattern in this mission is applying it to the secret itself. It is an honest-looking one-line change and it
usually arrives with a good reason ("the crew needs to see it loaded"). But the file it feeds is readable by everyone, and
the unmasked local also flows into plans that CI systems log and archive.

Notice what the fixed version proves: you can give people useful information (the code is loaded, and it has six characters)
without giving them the code. A good review question for any `nonsensitive()` call is "if this value were pasted into
a public channel, would that be a problem?" Remember too that the redaction is a display feature: the state file and
`terraform output -json` still hold the real value, which is why the output keeps the real value for machine consumers and
why state itself must be protected.
