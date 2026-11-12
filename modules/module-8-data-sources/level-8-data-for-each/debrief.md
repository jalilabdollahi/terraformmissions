# Debrief — for_each on data sources: keys are the contract

`for_each` on a `data` block creates one data source instance per element and addresses each by a key:
`data.local_file.sample["b07-oak.txt"]`. Because instances live in a map, adding or removing a sheet
leaves every other instance untouched, which is the main advantage over `count`.

Three details from this mission are worth remembering.

**`fileset()` returns relative names.** It gives you `b07-oak.txt`, not `samples/b07-oak.txt`, and
`each.value` for a set is the same string as `each.key`. Whatever you pass to the provider must be
built into a real path with `path.module`.

**The result is a map, not a list.** Splat expressions (`[*]`) only work on lists, sets and tuples,
so a `for_each` data source needs a `for` expression (or `values(...)` / `keys(...)`) to be reshaped.
Each instance is still an object with the provider's attributes, like `content`.

**Keys leak into everything you build from them.** The instance key was the file name, so the
natural map you derive carries the extension. If consumers want barrel ids, transform the key at the
boundary, once, in a local, rather than at every use. Remember that keys must be known at plan
time: a `fileset` over files that exist before the run is fine, but a key derived from another
resource's output attribute would fail with "Invalid for_each argument".

The validator relies on exactly this: it drops a new sheet in `samples/` and expects a new barrel to
appear without any code change.
