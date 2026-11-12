# Debrief — for_each instances have names, not numbers

`for_each` creates one module instance per element of a map or a set of strings. Each instance's identity is its
**key**, and that identity appears in state addresses (`module.piece["vase"]`) and in references from outside
(`module.piece["vase"].hours`). Because the key is part of the address, adding or removing an entry affects only that
instance; the others stay untouched, which is the main advantage over `count`.

Terraform insists on sets and maps because keys must be unique and known during planning. A list may contain
duplicates and has no keys of its own, so you convert it explicitly: `toset(var.pieces)`. A side effect of sets is
that iteration order is sorted, not the order of your list; that is why the board is alphabetical.

When you write an indexing expression remember the key is *data*. `"Vase"` and `"vase"` are different keys and
Terraform reports an invalid index at plan time, naming the available collection. For robust code, avoid hardcoding
a key that a user-supplied collection might not contain; iterate with `for k, m in module.piece` as the board does, or
use `try(module.piece["vase"].hours, null)`.

**Takeaway:** use `for_each = toset(list)` for named module instances, expect state addresses with string keys, and
spell keys exactly as the collection does.
