# Debrief — sets, and why order matters in one of them

Terraform has three set-algebra functions, and each answers a different question about two or more
collections:

- `setunion(a, b, ...)`: everything that appears in any argument, once.
- `setintersection(a, b, ...)`: only elements that appear in all arguments.
- `setsubtract(a, b)`: elements of `a` that are not in `b`.

Every one of them returns a **set**: no duplicates, no meaningful order (Terraform displays and
serializes it sorted). They accept lists as input and convert them, which is why the doubled "Rhys"
and "Bryn" in the sign-up sheets vanish without any special code.

The first two are symmetric; swapping arguments changes nothing. `setsubtract` is not. Swapping its
arguments answers a different question ("who owns a robe but is not singing?") and returns a
plausible-looking list, so the error never announces itself. When a function is not commutative,
read it aloud: "concert singers minus robe owners".

`concat()` is the tempting wrong tool for union. It keeps duplicates and order, producing a list of
eleven names where there are six singers.

Finally, a set cannot be indexed. If you need to sort or index, convert with `tolist()` or
`sort(tolist(...))`, as the robe-list file does.

## Real-world takeaway

Allowed CIDRs minus blocked CIDRs, desired users minus existing users, tags on both resources: these
are set problems in disguise. Use the set functions, and add an assertion with a nontrivial example
so a reversed subtraction is caught on the first run.
