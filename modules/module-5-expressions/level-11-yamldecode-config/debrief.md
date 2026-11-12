# Debrief — YAML decides types before Terraform sees them

`yamldecode()` returns a Terraform value from YAML text, and the types are decided by the YAML parser,
not by your variable declarations. Two classic surprises appear here:

- **Bare words that mean booleans.** In the YAML 1.1 style that Terraform follows, `no`, `off`, `yes`,
  `on` (in several capitalizations) are booleans. A country or language code like Norway's `no` becomes
  `false`. This is the famous "Norway problem".
- **Numbers that look like versions.** `2.10` is the number 2.1, and `1.0` is the number 1. A version
  string must be quoted to stay a string.

Once the parser has converted the value, the original text is gone. You cannot fix `false` back into
`"no"` in HCL, so the repair belongs in the YAML: quote any value that must be text.

The other half of the mission was structural. `yamldecode()` returns nested objects, so the path
mirrors the indentation: `local.cfg.submarine.crew`. When you are unsure, assign the decoded
value to a local and inspect it in `terraform console`, or output it temporarily.

## Real-world takeaway

Configuration read from YAML is untyped input. Quote versions, country codes, zip codes with leading
zeros and anything else that is not meant to be a number or boolean. In Terraform, validate the shape
you rely on with a `variable` type constraint or a `precondition`, so a wrong type fails with a clear
message instead of producing the string "false" in a production file.
