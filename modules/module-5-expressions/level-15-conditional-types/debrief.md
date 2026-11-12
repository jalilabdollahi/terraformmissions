# Debrief — one expression, one type

A conditional `cond ? a : b` is a single expression, so it has a single type. Terraform tries to
unify the two branches. Sometimes it can: a number and a string are both converted to string. Other
times it cannot, as with a list and a string, and the plan stops with "Inconsistent conditional result
types".

The first outcome is more dangerous than the error. `junior ? 0.5 : "full"` is accepted, but the type
becomes `string` in both cases, so a junior's factor is the text `"0.5"`. Terraform will still convert
it back in arithmetic, so the problem may lie dormant until a guest is not a junior: `80 * "full"`
cannot be evaluated. This is why the check looks at the JSON type of every output.

Design rules that avoid the problem:

- Use "neutral" values to represent "nothing special": `1` for a multiplier, `[]` for no items, `{}` for
  no settings, `""` for no suffix.
- Use `null` only when the consumer genuinely accepts null (many resource arguments treat it as
  "not set"). `null` converts to any type, so it is safe in either branch.
- When branches are objects with different attributes, add the missing keys or convert both
  sides explicitly with `tomap()` or `tolist()`.

## Real-world takeaway

Conditionals show up everywhere: optional resources, size per environment, lists of subnets for
prod vs dev. Decide the type first, and make both branches produce it. Then test the expression with
both values of the condition, because an untaken branch can hide a type or operand error until the day
the condition flips.
