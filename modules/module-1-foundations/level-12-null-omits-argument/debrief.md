# Debrief — Static And Signal Slugs

**What broke.** The variable's default was an empty string, which looks like "nothing" to a human but is a
perfectly real value to Terraform. `random_pet` therefore joined the words with an empty separator
instead of its default dash. No error, no warning, only odd-looking slugs.

**Null is "not set".** In Terraform, `null` means *absent*. When you assign `null` to an optional
argument, Terraform behaves as if you never wrote the argument, and the provider supplies its own default.
That is why `null` is the right way to say "the caller did not choose". Empty strings, empty lists and `0`
are all values that the provider will honour literally.

**Where it matters.** Optional settings that you pass through from variables (`description`, `kms_key_id`,
`domain`, `separator`) should default to `null`, not `""`. Otherwise an unset variable can overwrite a
sensible provider default, or even fail validation on the provider side because `""` is not an acceptable value.

**Conditional pass-through.** When a caller might supply an empty string, normalise it:
`var.x == "" ? null : var.x`, or use `try()` and `coalesce()` carefully (note that `coalesce` skips empty
strings but errors if everything is empty or null).

**Real-world takeaway.** Use `null` as the "unset" marker for optional inputs, and verify both the default
path and the override path of any pass-through variable.
