# Debrief - keys are public, values may not be

Terraform stores `for_each` keys in the address of every instance: `pin_slip["vesna"]`. Addresses show up
in plans, logs, state listings and error messages. If the key were derived from a secret, the secret
would leak into all of them, so Terraform refuses sensitive values as `for_each` input outright.

The fix is a deliberate split of what is secret and what is not. `keys(var.pins)` is a list of names -
derived from a sensitive map, so Terraform marks it sensitive too (it cannot know the keys alone are
harmless). `nonsensitive()` is the explicit "I vouch for this value" function. You use it on the narrowest
possible expression, the names, and leave the PINs where they are: read through `var.pins[each.key]` and
still marked sensitive wherever they are used.

## What not to do

`nonsensitive(var.pins)` would compile, but it strips protection from the PINs too, and they would appear
in plan output. The validator rejects that and searches the plan for the PIN values.

Also check the key choice itself: if the name *were* a secret (an API token used as a key, for example),
the right design is to key by a different, public identifier such as an index or a label, and keep the
token as a value.

## Real-world takeaway

Design variables so identifiers and secrets live in different places: `map(object({ secret = string }))`
with a non-sensitive key, or two inputs. Use `nonsensitive()` sparingly, narrowly, and with a comment
saying why the value is safe.
