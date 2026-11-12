# Debrief — Wax And Groove Prices

**What broke.** The file started with `--`, continued with `;`, and held an HTML comment. Each is a perfectly
good comment in another language (SQL, INI/assembly, HTML) and an immediate parse error in HCL. Unlike a
missing brace, these errors are reported at the exact line, because the parser sees a token it has no rule for.

**The three HCL comment styles.**
- `# text`, the idiomatic single-line style (what `terraform fmt` and the docs use).
- `// text`, an alternative single-line style, accepted but rarer.
- `/* text */`, a block that may span lines; it cannot be nested.

Comments are removed during parsing, so they never reach state, plans or providers. They are the only
place where you can write anything at all, but you should also avoid putting secrets in them: they stay
in version control forever.

**What else the file demonstrates.** The records were stored in a map and the price list built with a `for`
expression and `format("%.2f", ...)`. Maps iterate in alphabetical key order, which is why the CSV order
differs from the order in the source. Changing `markup_pct` still changes the output, which the validator checks.

**Real-world takeaway.** When you paste text from another ecosystem, convert comments first. For
Terraform, make `#` your standard, and use `terraform fmt` to tidy the rest: it will not repair foreign
comment syntax, but it will make misplaced text easier to spot.
