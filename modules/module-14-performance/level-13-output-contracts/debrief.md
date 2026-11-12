# Debrief — outputs are an API

Between teams, a module's outputs (and the variables it accepts) are a public interface. Renaming an
output is a breaking change to every caller, exactly like renaming a function parameter, and the
failure shows up in somebody else's pipeline. A written **contract** makes the rules explicit:

- **One versioned object.** Publishing `stage_contract` with a `version` field lets consumers
  check what they are getting. Add fields in minor versions; rename, remove or retype only in a major version.
- **Deprecate, don't delete.** Terraform's `deprecated` argument on module outputs and variables
  prints a warning to every caller that still uses the old name, so you can set a removal date and
  migrate teams one by one instead of all at once.
- **Consumers validate.** A `precondition` on the first resource that uses the contract turns a
  silent semantic change into a clear plan-time error, with a message that says which version it expects.
- **Own your side only.** The rigging team's file is untouched; the fix lives in the producer, and
  consumers migrate on their own schedule.

The same applies across state files (`terraform_remote_state` outputs) and, even more strongly, there,
because producer and consumer are applied at different times and nothing checks them against each other
until the consumer plans.

Real-world takeaway: treat outputs like an API, version them, deprecate before removing, and add a guard
where you consume them.
