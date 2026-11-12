# Debrief - zero-based machines, one-based people

Terraform's `count.index` runs from 0 to `count - 1`. That is the right choice for addressing: list
indexes start at 0, and `local_file.bay_sign[0]` is the first instance. But a label a driver reads is a
different kind of value. Humans start counting at one, so the label needs a conversion, and the conversion
belongs at the point where the number is *displayed*.

The off-by-one here was easy to miss because nothing failed. Six signs were created, the plan was clean,
and only a person standing on the deck noticed BAY 0 and the missing last bay.

## What not to change

The instance count and the instance addresses stay as they are. If you were tempted to write
`count = var.bays + 1` and skip the first index, you would have invented seven resources for six bays and
a resource that exists only to be ignored. Keep `count = var.bays` and add one where the number is shown.

## Real-world takeaway

Whenever a number from `count.index` leaves Terraform - a hostname such as `web-01`, a VLAN id, a
printed label - decide explicitly whether it is an index or an ordinal. `format("%02d", count.index + 1)`
is the common idiom for fixed-width ordinals. Also keep in mind that renumbering names later forces
replacement of the objects carrying them, so choose the numbering convention before the first apply.
The validator checked a plan for nine bays: the ninth sign must read BAY 9, proving the offset is applied
everywhere, not only for six.
