# Debrief — directives are text too

Terraform string templates have two kinds of marker: interpolation (`${...}`) and **directives**
(`%{ if ... }`, `%{ for ... }`, `%{ else }`, `%{ endif }`, `%{ endfor }`). Directives let one template
produce different text depending on data, which is why they are popular for config files and
reports.

The catch is that the template is plain text with markers in it. When a directive sits alone on a line,
the markers disappear but the **line break stays**, so every iteration of a loop and every branch
of a condition adds an empty line to the output.

The strip marker `~` fixes that. Inside the braces, next to the delimiter:

- `%{ for x in list ~}` removes the whitespace and newline **after** the directive,
- `%{~ endfor }` removes the whitespace and newline **before** it,
- both can be used together, as in `%{~ if cond ~}`.

Choosing where to put the tilde takes practice, because it eats all adjacent whitespace, including
the indentation you may want to keep. A reliable method: write the template the way it should look, then
add `~` to the end of each directive that owns a line and compare the rendered output.

Directives also work inside `templatefile()` files, which is the usual place for long ones. For
anything with complicated logic, build the data in HCL first (a list of ready-made lines) and keep the
template to simple loops. Whitespace control in templates is brittle, and a text diff in a
test or plan output is the only reliable review.

## Real-world takeaway

Generated YAML, nginx configs and systemd units are whitespace-sensitive. A stray blank line is
cosmetic in a manifest, but in a config file it can change meaning. Render the template with both a
normal and an empty input, and compare character by character.
