# Debrief — rotation should be a decision

Generated secrets live in state, and Terraform will keep them as long as nothing forces a replacement. That stability is a feature:
every consumer of the password sees the same value from run to run. But you still need a way to rotate on purpose — after a
staff change, an incident, or a quarterly policy. `keepers` is that handle. It is a map of arbitrary strings stored beside the resource; when any value
differs from the stored one, the provider replaces the resource and a new value is generated.

The common mistake is picking a keeper that changes by itself. `timestamp()`, `uuid()` and file hashes of files that Terraform itself rewrites all
cause permanent diffs: the plan is never clean, and the secret rotates under every apply, locking out the systems that consume it. A good keeper is
something a human changes deliberately — a ticket number, a rotation epoch, a policy version — or a value that *should* trigger rotation, such as the identity of the user the password belongs to.

Pair rotation with the rest of the chain: the downstream resource (here the locker file) is updated in the same apply because it references the password,
but any external system holding the old value still needs to be updated by whatever consumes the new one.
