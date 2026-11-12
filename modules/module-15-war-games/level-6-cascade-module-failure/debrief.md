# Post-mortem — Tern Field Baggage Cascade

**Timeline.** 04:50 the sortation release merged to main. 05:05 the pipeline failed with a single type error in the
belts call. 05:20 fixing it exposed the next error in the sorters call, and 05:35 the dispatch module planned
fine but published a wrong total, found only because a supervisor compared the board to the belt sheet.

**Root causes.**
1. Three modules were rewritten in one change with no plan against real state.
2. The belts rewrite bumped `byte_length`, a force-new argument, so applying the "fix" would have regenerated
   every belt serial.
3. Interface drift: an output was renamed and an input added without updating all callers.
4. A logic error in dispatch assumed equal sorter sizes and used `keys()[0]` as a proxy for "largest".

**Lessons.** Terraform evaluates the module tree lazily and in dependency order, so the first red error is
rarely the last. A cascade is resolved top-down, re-validating after each fix, and the plan must be read for
replacements after every layer. Wrong outputs are the most dangerous layer because nothing fails.

**Prevention.**
- Change module interfaces behind a version or in separate PRs.
- Review plans, not just validate output, for any module that owns state.
- Pin force-new arguments in tests (`terraform test` with `plan` assertions on IDs).
- Add output assertions for computed totals.
