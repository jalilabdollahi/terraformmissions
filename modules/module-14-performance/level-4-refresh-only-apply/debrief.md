# Debrief — refresh-only is how you accept what already happened

Terraform stores a *snapshot* of what it believes exists. When the real world moves (an operator
edits something, a data source's backing file changes, a service updates a computed attribute),
state falls behind. A normal plan refreshes in memory, shows "Changes outside of Terraform", and then
plans changes to make reality match **the configuration**.

`terraform apply -refresh-only` runs only the refresh half and then writes the result to state. No
resource is created, updated or destroyed. That is exactly what you want when:

- the drift is legitimate and the code should be updated to match later (record now, fix code in a
  review), or
- other values derive from the changed data (outputs, data sources, other stacks reading
  `terraform_remote_state`) and need to be current *now*, while a pending, unrelated code change must
  wait for its own review.

It is not a "fix drift" button: if the config disagrees with the real object, the next normal apply
will still revert it. Older Terraform versions had `terraform refresh`, which did the same without
showing a plan. `apply -refresh-only` is the safer replacement because you approve what gets
recorded.

Real-world takeaway: when a plan mixes "the world changed" with "someone's code changed", split the
two. Accept the first with `-refresh-only`, send the second through review, and verify with
`plan -refresh-only` that nothing is left unrecorded.
