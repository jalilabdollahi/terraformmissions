# Debrief - zero-or-one dynamic blocks

Some nested blocks must exist or not exist; there is no way to write "this block, but only if". The
idiom for that is a `dynamic` block whose `for_each` is either an empty list or a list with one element:

`for_each = var.transcript == null ? [] : [var.transcript]`

An empty collection generates no blocks; a one-element collection generates exactly one, and the
element is available as `source.value`. This is the standard trick for optional nested blocks, such as
an optional `lifecycle_rule`, `logging` or `sse` block on cloud resources, and it is the nested-block
twin of `count = var.enabled ? 1 : 0` for whole resources.

## Why the original failed

With the block static, a null transcript gives the block a null `content`. The provider schema marks that
argument required, so planning stops. Making the *argument* conditional (`coalesce`, `try`) would only
swap one error for an entry with an empty file or the wrong behaviour. The fix is structural.

## Variants

- `for_each = var.x != null ? [var.x] : []` is identical.
- `for_each = compact([var.x])` handles empty strings as well as null, but only for strings.
- `for_each = var.rules` (a list of objects) is the same pattern with zero-to-many elements.

## Real-world takeaway

If you ever find yourself writing `try()` around every attribute of a block to avoid errors, step back: the
block is probably optional. The validator applied three times - null, a transcript, then null again - to
prove the entry appears and disappears, and that a final plan is clean.
