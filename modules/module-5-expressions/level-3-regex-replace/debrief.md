# Debrief — the slashes make it a regex

Terraform's `replace(string, substring, replacement)` has a quiet split personality. If the second
argument is plain text, it replaces every literal occurrence. If the second argument **starts and ends
with a forward slash**, Terraform compiles it as a regular expression (RE2 syntax) and the replacement
may refer to capture groups as `$1`, `$2`, and so on.

That is why this mission never produced an error. `"[^A-Za-z0-9]"` is perfectly valid text to search
for. It just does not appear in the input, so the string comes back unchanged and `apply` succeeds.
Bugs of this shape are the worst kind: the failure is in the data, not in the run.

Two more details are worth remembering:

- HCL string escapes come first, so a regex `\s` must be written `\\s` in the source (or use a heredoc
  or a character class like `[[:space:]]`).
- Capture groups let you reorder text without a chain of `split` and `join`. The replacement
  `"$3/$2/$1"` turns `2026-03-17` into `17/03/2026`. To write a real dollar sign, double it: `$$`.

## Real-world takeaway

Use regex replacement to normalize names before they become resource names, bucket names or DNS
labels, which have strict character rules. Always verify with `terraform console` using a deliberately
ugly input, and check the argument order every time. A function that does not error is not a function
that works.
