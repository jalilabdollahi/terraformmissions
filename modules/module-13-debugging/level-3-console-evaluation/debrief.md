# Debrief - console first, apply later

`terraform console` evaluates any expression against your configuration and current state, read-only. It is the
fastest feedback loop Terraform has: instead of editing, planning and reading a diff, you type
`local.usable` and see the value immediately. For complicated `for` expressions, nested lookups and function
chains, the habit is to build the expression from the inside out, checking each stage.

This level hides two kinds of bug that behave very differently:

- A **loud** one: `Duplicate object key`. A `for` expression that produces an object needs unique keys; when a key
  repeats, the trailing `...` groups the values into a list instead.
- A **silent** one: `sort()` accepts only strings, so numbers that came out of `csvdecode` (all strings!) are ordered
  alphabetically. "9" sorts after "88". No error is raised; the output is just wrong. Silent logic bugs like this are
  the reason to inspect intermediate values instead of trusting the final output.

Other things worth remembering about the console: it locks the state while open for reading (do not leave a
session in a pipeline), `terraform console` can take a piped expression (`echo 'local.usable' | terraform console`) for
scripts, and `-var` flags work as they do for plan. For numeric ordering of structured data you will often
reach for padded keys, `max()` in a loop with `setsubtract`, or move the sorting out of HCL entirely.
