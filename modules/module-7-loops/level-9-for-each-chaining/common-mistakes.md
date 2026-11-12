# Common mistakes

- **Adding `[each.key]` without a `for_each` on the card.** The card is still one resource, so the
  filename is just one of the cadets' sign.
- **Using `count = length(var.cadets)` on the card with `random_pet.callsign[var.cadets[count.index]]`.**
  It works until the list is reordered, and it gives the cards positional addresses instead of names.
- **Repeating `for_each = toset(var.cadets)` on the card.** It plans, but the resources are no longer
  chained, which this mission tests for by name.
- **Switching `random_pet` to `count` too.** Then the callsigns shift when a cadet leaves the middle of
  the list - the instability this pattern avoids.
