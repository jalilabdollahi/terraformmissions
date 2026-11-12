# Debrief - a counted resource is a list

As soon as a resource has `count`, the name `local_file.closure` stops referring to one object and
starts referring to a **list of objects**. Writing `local_file.closure[0]` picks one element; writing
`local_file.closure[*].filename` - the splat expression - maps over all of them and gives you a list of
one attribute.

The hard-coded `[0]` is a classic leftover. It was correct when the resource had no count, or when the
author expected exactly one instance, and it kept working after `count` was added, so nobody noticed. It
only misbehaves when someone reads the output: the list is truncated to one entry. And it breaks
completely when the count drops to zero, because there is no element 0 to read.

## Splat versus for

Splat is perfect for plucking one attribute. If you need to transform the value, filter, or build a
map, use a `for` expression: `[for c in local_file.closure : upper(c.filename)]`. Both preserve instance
order, which equals `count.index` order.

## Real-world takeaway

When you add `count` to a resource that other code already references, grep for every reference and
decide per site: all instances (`[*]`), one specific instance (`[0]`) or optionally-one (`one(...)`).
The empty-schedule plan in the validator was deliberate: a robust output works at zero, one and many
instances, and splat does.
