# Common mistakes

- **Moving to the same address three times.** `random_id.batch` exists in all three source states; mapping each to a root-level `random_id.batch` collides, and `state mv` refuses or overwrites. Every team goes under its own module prefix.
- **Trusting the empty cellar state.** `terraform state list` in `stacks/cellar` shows nothing in the default workspace. The real objects are in `autumn`; merging "nothing" makes the merged plan create a second cellar.
- **Applying the merged stack before it is right.** With `quota_max = 210` and `quota_min = 4`, the plan replaces two quotas, and applying re-rolls numbers already in the paperwork.
- **Editing the module to accept the wrong ranges.** The ranges belong to the teams, and the module is shared; correct the calls, not the module.
- **Leaving the old team code in place.** With empty state, the next apply in an old stack builds the whole team again.
