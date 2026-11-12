# Common mistakes

- **Running a plain `terraform apply` instead.** It converges the state, but nobody approved that
  plan, and the mission demands a saved plan file that was applied.
- **Deleting plan.tfplan and carrying on.** The validator looks for a fresh saved plan that contains
  the creations that were applied.
- **Saving the plan after the apply.** The new plan file then says "no changes" and proves nothing;
  plan, review, then apply the file.
- **Trying to patch or force the stale plan.** There is no `-force`; the state serial it was made
  from no longer exists, and re-planning is the only way.
- **Applying with `-target` to match the plan.** It leaves hearings out and the plan unclean.
