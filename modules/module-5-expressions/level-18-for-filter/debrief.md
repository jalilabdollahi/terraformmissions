# Debrief — the if clause is only as good as its condition

A `for` expression can end with an `if` clause: `[for t in towers : t if condition]`. Elements for
which the condition is false are dropped. Because a wrong condition drops elements instead of raising an
error, filter bugs usually look like "the list is mysteriously empty" or "one item is missing".

Two causes in this level are worth knowing by heart.

**`==` compares type and value.** In Terraform, `true == "true"` is `false`, and so is `1 == "1"`. A bool
that came from a typed variable is a bool; comparing it with a string can never succeed. Use the
boolean directly: `if t.staffed`, or `if !t.staffed` for the opposite. Terraform does convert types in
other places, such as string interpolation, which is why this one catches people out.

**Strict versus inclusive comparisons.** `>` and `>=` differ exactly at the boundary, and boundary cases
are where requirements like "at least 25 m" live. Test them on purpose, with a value equal to the limit.

The condition can use any expression, including other variables (`var.min_height_m`), functions
(`contains(var.regions, t.region)`), and `&&`, `||`, `!` combinations. Remember that `&&` binds tighter
than `||`; use parentheses when mixing.

For map results, the same clause works: `{ for t in towers : t.name => t.height_m if ... }`.

## Real-world takeaway

Filter bugs are silent, so assert on counts. Add an output such as `length(local.on_watch)` or a
`check` block, run it with a dataset containing the boundary values, and compare to what you expect
from reading the data by hand.
