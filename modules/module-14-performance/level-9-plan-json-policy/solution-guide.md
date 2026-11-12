# Walkthrough — Bonded Warehouse Gate

1. **Make test plans.** `terraform show -json plan.tfplan > plan.json`. Copy it to `bad-*.json` and edit
   `change.actions` / `change.after.file_permission` by hand to try each rule.
2. **Find the four bugs in `policy/check.sh`.**
   - R1: `select(.change.actions == ["delete"])` misses `["delete","create"]` and `["create","delete"]`;
     use `(.change.actions | index("delete")) != null`.
   - R2: `.change.before` is `null` for a created file, `test()` on null raises an error, `2>/dev/null`
     hides it, and the filter prints nothing. Use `.change.after.file_permission // ""` and only for
     create/update.
   - R3: not implemented. Add `^(\./)?bonded/` and `contains("..") | not`.
   - Exit codes: nothing checks that jq succeeded. Test the file is readable and `jq -e .` parses it
     first and exit 2 otherwise.
3. **Print a `VIOLATION: <address>: <reason>` line per problem** and `exit 1` if any exist.
4. **Run every case.** Compliant plan: exit 0. Replace plan: exit 1. `echo nope > x.json`: exit 2.
   Data sources and no-op entries must not be reported.
