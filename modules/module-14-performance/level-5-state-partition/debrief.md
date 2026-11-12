# Debrief — smaller states, explicit contracts

One state file per big configuration means every plan refreshes everything, every apply takes the
same lock, and a mistake anywhere has the whole estate in range. Partitioning splits that by rate of
change and ownership: slow, risky foundations in one root module, fast daily churn in another.

Partitioning has two halves that people routinely do in the wrong order:

1. **Move the objects.** `terraform state mv -state-out=...` (or `terraform state rm` plus an `import`
   in the other root) transfers the record of an object without touching the real thing. If you just
   delete the resources from the old config and recreate them in the new one, the real objects are
   destroyed and re-created (new random names, new IDs, new IP addresses).
2. **Define the contract.** The consumer must not reach into the other configuration's resources; it
   reads **outputs**, via `terraform_remote_state` or a better-managed channel (SSM parameters, a
   registry, a data source lookup). Outputs are the API; the producer has to apply after adding them,
   as the consumer reads the *state*, not the code.

The cost is ordering: core must be applied before the roster, and you give up the single graph, so
cross-state dependencies become your responsibility. That is acceptable for foundations that change
monthly, and a poor trade for two resources that change together.

Real-world takeaway: split states along "who changes it and how often", back up both states first,
move before you apply, and treat outputs as a versioned interface.
