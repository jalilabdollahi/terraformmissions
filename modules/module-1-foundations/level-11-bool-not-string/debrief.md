# Debrief — Driftwood Wi-Fi Vouchers

**What broke.** `random_string` has four switches (`upper`, `lower`, `numeric`, `special`) and each one is
a `bool` in the provider's schema. The author wrote human words: `"yes"`, `"disabled"`, `"enabled"`,
`"no"`. Terraform's automatic conversion for booleans only recognises the strings `"true"` and
`"false"`, so anything else fails with "a bool is required".

**Read the intent, not just the word.** The comment at the top of the file explains what the printer
needs: capitals and digits, nothing else. So `"enabled"` maps to `true` and `"disabled"` to `false`; the
mapping you choose has to match the requirement. The validator checks the generated voucher against
`^[A-Z0-9]{8}$`, so a wrong mapping fails even if the syntax is correct.

**Defaults matter.** Every character class defaults to `true`. If you simply deleted the
bad lines, the voucher would contain lowercase letters and symbols again. When behaviour must be
off, say so explicitly with `false`.

**Real-world takeaway.** Boolean arguments appear everywhere: `encrypted`, `publicly_accessible`,
`force_destroy`, `enable_https`. Unquoted `true` and `false` are always the safest spelling. Quoted
booleans work only by accident of conversion, and values like "yes" or "on", common in YAML and
shell, never convert. When you build conditions, remember that a bool variable should be typed `bool`
so that bad input is rejected early.
