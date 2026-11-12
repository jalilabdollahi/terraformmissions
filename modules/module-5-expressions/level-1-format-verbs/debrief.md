# Debrief — format() is printf in disguise

`format()` copies the C-style `printf` family: a verb such as `%s`, `%d`, `%f` or `%q` marks where an
argument goes, and optional flags between the percent sign and the letter control the shape.

Three details caused trouble here:

- **`%d` is strict.** It accepts only whole numbers. Give it `21.1` and Terraform stops with "an
  integer is required" rather than rounding quietly. Use `%f` (or `%.1f`) for fractions.
- **Padding flags.** `%5d` pads with spaces to width 5; `%05d` pads with zeros. The error is silent,
  because both are valid. Only the output tells you, which is why a validator (or a plan review)
  should compare real strings.
- **`%q`** prints a string in double quotes and escapes embedded quotes, which is exactly what you want
  when a name can contain punctuation and the line may later be parsed by something else.

The width in `%05.1f` counts the whole field including the decimal point, so `21.1` becomes `021.1`.

## Real-world takeaway

Resource names, tags and file contents built with `format()` often end up in systems that care about
exact text: sort order of zero-padded IDs, quoted fields in CSV-like lines, fixed-width reports. Test
a format string in `terraform console` with a normal value and an awkward one (large, fractional, or
containing quotes) before you trust it. Prefer `format()` over long chains of `"${...}"` when
you need padding or precision, because the intent lives in one readable template.
