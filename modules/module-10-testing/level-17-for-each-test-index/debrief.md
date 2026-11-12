# Debrief - instances have keys

When a resource uses `for_each`, Terraform tracks one instance per key, and the resource address
`local_file.stand_card` refers to the whole **map** of instances. Inside a test you reach one with
`local_file.stand_card["arrow"]`, which is the same bracket-and-quotes notation you see in
`terraform state list` and in plan output. With `count` the same resource would be a **list**, addressed
with `[0]`. Mixing the two is a very common slip, and Terraform's message ("an object only supports looking up attributes by name") is accurate but does not say that the real issue is count versus for_each.

Why prefer keys to positions? Keys survive reordering and removal. A test that says "the saloon's card
has stand 7" keeps meaning that if someone adds a entry above it, while "card number 1" silently changes
meaning. It is the same reason `for_each` beats `count` in the code itself.

For whole-collection facts use functions that work on maps: `length(local_file.stand_card)`, `keys(...)`, or a
`for` expression such as `alltrue([for k, f in local_file.stand_card : ...])`. They keep passing when you add
a entry, and they fail loudly if a entry loses its card.

Also remember that plan-mode runs can only assert on attributes known at plan time. Names, paths and
contents built from variables are known; IDs, hashes of unknown content are not.

Real-world takeaway: assert specific instances by key for the cases you care about, and collection-wide
properties with `length`, `keys` and `alltrue` for the invariants.
