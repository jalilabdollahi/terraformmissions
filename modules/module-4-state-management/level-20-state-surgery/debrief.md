# Debrief — a messy state is just a list of small problems

Real state problems rarely come alone. A refactor, a lost state file and a hand-over land in the same
week, and the plan becomes one long list of destroys and creates. The skill is to read that list as *pairs
and orphans* and to pick the smallest tool for each:

| Plan says | Meaning | Tool |
|---|---|---|
| destroy X, create Y (same kind) | same object, new address | `terraform state mv X Y` |
| create Z, but Z exists for real | state lost it | `terraform import Z ID` |
| destroy W, but W must live on | code dropped it, someone else owns it | `terraform state rm W` |

Practical rules for surgery:

1. **Back up first:** `terraform state pull > before-surgery.tfstate`. State commands also keep timestamped backups, but your own copy is the one
   you will remember.
2. **One fix per step, plan after each.** The destroy/create list should shrink every time. If a step makes it
   longer, stop and look.
3. **Never `apply` in the middle.** A half-fixed state plus an apply destroys exactly the objects you were saving.
4. **Prefer declarative blocks (`moved`, `import`, `removed`) in shared code**; the CLI is for when you own the state and need a fix today.

When the plan is clean again, the state, the code and the real world agree, and you can proceed with the work you
actually intended.
