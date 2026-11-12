# Debrief — approve the plan, not the intention

`terraform plan` followed by `terraform apply` are two separate computations. If somebody else changes
state or the real world between them, the second plan is not the one the reviewer read. A **saved
plan** closes that gap: `terraform plan -out=plan.tfplan` records the exact actions, and
`terraform apply plan.tfplan` executes precisely those, with no prompt, or refuses.

The refusal is the safety feature. Terraform ties a plan to the state serial and lineage it was
computed from. If anything has moved since, the plan is "stale": its assumptions are false, and
applying it could, for example, create something that now exists. The correct response is never to
force it, but to re-plan and get the new plan reviewed again.

Pipelines that adopt this pattern usually:

- run `plan -out` in the pull-request job and upload the plan file as an artifact;
- apply that same artifact after merge or approval, using a state lock so no one slips in;
- inspect the plan with `terraform show -json` (policy checks, cost estimates) before approval;
- treat plan files as sensitive: they can contain secret values in plain text.

Real-world takeaway: for any change that needs sign-off, the unit of approval is a plan file, and a
"stale plan" error means the world moved, so plan again and ask again.
