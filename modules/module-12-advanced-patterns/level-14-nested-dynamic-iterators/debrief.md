# Debrief: every loop introduces names, and inner names win

A `dynamic` block has an iterator whose name defaults to the block label (`source` here). Inside `content` you
refer to the current element as `<iterator>.key` and `<iterator>.value`. Setting `iterator = sheet` renames it, which is
helpful when dynamic blocks are nested, because then each level needs a distinct name or the inner one hides the outer one.

In the level the provider has no block that contains another repeatable block, so the nesting happens in the
`for` expressions that feed the dynamic block: a workshop loop with a piece loop inside, flattened into one list. The same
shadowing rule applies. In `for a, b in x`, the symbols exist only inside that expression, and an inner `for` that
reuses an outer name replaces it silently. For lists the first symbol is the index, so `shop` quietly became 0, 1.

Two habits prevent most of this. Give every loop distinct names (workshop, piece, never `k` twice), and use
`_` for symbols you do not need. And inspect the result, not just the plan: for any generated structure,
`terraform console` or an output will show the real names long before a customer does.

Real-world takeaway: nested dynamic blocks, as in security groups with rules with ranges, follow the same
logic. Name each iterator after what it iterates, and the content block will read like a sentence.
