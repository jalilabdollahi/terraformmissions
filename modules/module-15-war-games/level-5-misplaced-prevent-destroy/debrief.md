# Post-mortem — Calder Reach Annex Teardown

**Timeline.** Monday an audit added `prevent_destroy` to the annex berth tag as a "safety measure". Tuesday
CHG-2291 set `annex_enabled = false`. 09:00 every plan failed. A first instinct to delete the guard and apply
would have produced a plan that also replaced the charter serial, because its keepers tracked the annex flag.
On-call stopped, moved the guard to the charter and then found the keepers trap.

**Root causes.**
1. The guard was applied to the nearest resource rather than the irreplaceable one. A guard is a statement
   about value, not about proximity to a change ticket.
2. `keepers` on `random_id` is a replacement trigger. Feeding it an unrelated toggle means a decommission
   becomes an accident for the charter.
3. The root manifest indexed `module.annex[0]`, which cannot exist when the module is switched off.

**Lessons.** `prevent_destroy` only works while the resource is still in configuration; removing a block (or
setting `count` to 0 inside a module that remains) behaves differently from deleting a whole module call.
Putting the guard on the charter *first* turned a silent replacement into a loud failure, which is its purpose.
Plan output should be read for what happens to the objects you did not mean to touch.

**Prevention.**
- Protect identifiers that other organisations hold copies of; leave decommission targets unguarded.
- Never wire unrelated variables into `keepers`.
- Reference optional modules with `one()` or `try()`.
- Review decommission plans for every replacement, not only the destroys you expected.
