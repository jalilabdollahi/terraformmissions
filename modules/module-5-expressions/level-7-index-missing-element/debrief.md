# Debrief — functions that fail instead of returning "not found"

In many languages, searching for an element that is missing returns `-1`, `null` or `None`. Terraform's
`index()` does none of those: it raises an error and the plan stops. That is deliberate. Terraform
has no real null-propagation for list positions, and a silent default position could rotate a list
around the wrong element.

The fix is to ask the question first. `contains(list, value)` returns true or false and never fails, so
a conditional can choose between the successful `index()` call and a sensible fallback. Terraform only
evaluates the branch it needs, so `index()` is not called when `contains()` is false.

Other shapes of the same guard:

- `try(index(list, value), 0)` catches the error, but it also hides typos in the other arguments.
- `can(index(...))` returns a boolean, handy inside `validation` blocks.
- `one([for i, b in list : i if b == value])` returns null when absent, which is helpful if you want
  null rather than a numeric fallback.

The rotation itself uses `slice(list, start, end)`, whose end index is exclusive, and `concat()` to glue
the two pieces together. A start index of 0 produces an empty second slice, so the fallback needs no
special code.

## Real-world takeaway

Lookups driven by user input, such as "start from this region" or "primary node", will eventually get
a value that is not in the list. Decide what should happen then, deliberately. Failing loudly is
fine; it should be your choice, with a good message, not an accident of a function.
