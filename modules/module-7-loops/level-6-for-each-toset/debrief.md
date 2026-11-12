# Debrief - for_each needs unique keys

`count` identifies instances by position (`[0]`, `[1]`). `for_each` identifies them by **key**
(`["briggs"]`), and keys must be unique strings. So `for_each` only accepts two collection types: a
map (keys come with it) or a set of strings (each string is its own key). A list can contain duplicates
and has an order that means nothing as a key, so Terraform makes you decide: `toset(var.dealers)`.

`toset()` also deduplicates. In this mission briggs was typed twice; with the old `count` approach
that would have produced two stalls competing for one file name. With the set it is one instance, which
is usually what you want when the list is a bag of names.

## Why keys beat positions

Remove "calloway" from the middle of a `count`-based list and every later element shifts down one index,
so Terraform renames, replaces or destroys real objects that did not change. With `for_each` keyed by
name, deleting "calloway" removes exactly one instance and leaves the others untouched. That stability is
the reason `for_each` is the default choice for collections of distinct things.

## Real-world takeaway

Keep variables in the shape that is natural for callers (a list of names is friendly), and convert
inside the module with `toset()`. If you need to carry extra data per item, switch the variable to a
map of objects, which you will do in a later mission. The validator planned with
`["eldridge","eldridge","calloway"]` to prove the keys follow the data rather than the default list.
