# Debrief - the shape of a for_each resource

When a resource uses `count`, the resource name stands for a **list** of instances. When it uses
`for_each`, the name stands for a **map** of instances, keyed by the same keys as the collection you
iterated. You can index one instance (`local_file.ticket["poets-night"].filename`), or iterate all of
them, but you cannot ask the whole map for an attribute - a map has keys, not attributes. That is
exactly what the error "This object does not have an attribute named filename" is telling you.

The idiom you need is a `for` expression in braces:
`{ for key, instance in local_file.ticket : key => instance.filename }`. It preserves the keys, so the
output has the same shape as the input and consumers can look up `ticket_files["poets-night"]`.

If you only need the values, drop the braces for brackets, `[for t in local_file.ticket : t.filename]`,
or use the splat-on-values form `values(local_file.ticket)[*].filename`. Keep a map when the consumer
needs to find an item by name.

## Real-world takeaway

Outputs from a `for_each` resource - subnet IDs by name, bucket ARNs by team, certificate paths by host -
are among the most common outputs in real modules, and a keyed map is nearly always the right shape: it
is stable when entries are added or removed, unlike a list whose indexes shift. The validator ran a plan
with a different sessions variable to ensure the output is derived from the resource and not copied
from the defaults.
