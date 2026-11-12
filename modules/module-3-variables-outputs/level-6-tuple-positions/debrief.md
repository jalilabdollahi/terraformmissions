# Debrief — tuples are positional

A `list(...)` has one element type for every position; a `tuple([...])` has a type per position and
a fixed length. It is Terraform's way to model "a record without field names", like
`[station, temperature, online]`. Because positions carry the meaning, getting the order wrong is a
data bug, not a typing bug — and the error message is your only hint.

Notice how forgiving automatic conversion is: the number `18.5` can become the string `"18.5"`
and `true` can become `"true"`. A tuple like `[true, 18.5, "x"]` against `[string, number, bool]` would be
accepted for the first two positions and fail only at position 2. When a tuple error mentions a position
that looks "fine", suspect that an earlier position was silently converted.

If you find yourself writing comments to explain which index means what, switch to an `object`:
`{ station_id = "...", temp_c = 18.5, online = true }` is self-documenting, and `latest_reading.temp_c`
cannot be misread. Tuples are best when the order is natural (coordinates, RGB, a version triple) or
when you receive data from `jsondecode` or functions such as `zipmap` and `chunklist`.

## Real-world takeaway

Prefer objects for anything with more than two or three positions. Keep tuples for things that are
inherently positional, and put the position meaning in the variable's `description`.
