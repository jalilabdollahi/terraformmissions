# Debrief — replace exactly one object, on demand

Normally Terraform replaces an object only when your code changes in a way that cannot be done in place.
Sometimes you need a rebuild with no code change: a secret leaked, a server is misbehaving, a certificate
must be reissued. That is what `terraform apply -replace=ADDRESS` is for.

It is a *planned* operation. `terraform plan -replace=...` shows exactly what will happen, including side effects
on dependants (here the staff card file is rewritten with the new code). You can review the plan before you
commit to it.

It supersedes the older `terraform taint` command. Taint modifies the state ("this object is
broken") and leaves the rebuild for whichever apply happens next, possibly run by someone else. `-replace` does the
marking and the rebuilding in a single, reviewable command and never leaves the state half-way.

Practical points:

- Quote `for_each` addresses: `-replace='aws_instance.web["blue"]'`.
- Several objects: repeat the flag.
- Non-deterministic providers: a `random_*` replacement generates a *new* value. A replacement of a stateless
  resource like `random_integer` has no real-world side effect, but the same flag on a database destroys data.
- Prefer a code-driven trigger (`keepers`, `replace_triggered_by`) when the rotation is a scheduled, repeatable policy, and
  `-replace` when it is a one-off.
