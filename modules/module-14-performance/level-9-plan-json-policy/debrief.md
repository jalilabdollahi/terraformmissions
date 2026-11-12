# Debrief — a policy gate is only as good as its test plans

`terraform show -json` turns a plan into a stable, machine-readable document. A short jq script over
`resource_changes` is the cheapest policy engine there is: no new tool, no extra service, and it runs
on the exact artifact that will be applied (see the saved-plan level). Tools such as OPA, Conftest
or Sentinel do the same with more structure; the principles below apply to all of them.

Three things go wrong in hand-written gates:

- **Matching exact action lists.** A replacement is `["delete","create"]` (or `["create","delete"]`
  with create-before-destroy). Test for membership, not equality.
- **Looking at the wrong side of the change.** `before` is the prior state, `after` the proposed one.
  Policy about what will exist belongs on `after`, and `after` is `null` for deletes.
- **Failing open.** If jq errors (missing file, bad JSON, a `null` in a `test()`), a script that only
  prints violations will happily exit 0. A gate must exit non-zero when it cannot decide, and the
  pipeline must treat that as a block.

Write the gate against fixtures: one compliant plan, then one plan per rule, plus tricky neutrals
(no-op entries, data reads, empty plans). If the gate is not tested, its first real test is a
production incident.

Real-world takeaway: policy checks belong between `plan` and `apply`, run on the plan JSON, fail closed,
and come with their own regression plans.
