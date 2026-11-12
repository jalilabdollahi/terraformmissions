# Post-mortem — Skerrow Roster Module v2

**Timeline.** The module vendor tagged v2.0 on Thursday. Friday's bump PR passed `validate` after the interface
renames were fixed. 14:00 the release plan showed ten replacements and five card updates; the release was held.
Fix and verification took under an hour.

**Root causes.**
1. A major module version renamed resources, which Terraform cannot distinguish from "delete this, create that".
2. The module's changelog documented the renames, but the module shipped no `moved` blocks, so every consumer
   had to discover the migration on their own.
3. A default changed value. Defaults are part of a module's behaviour, and an unnoticed one is an unreviewed
   change to production.

**What was learned.** Resource renames inside a module are state migrations. The module author should ship the
`moved` blocks, but a consumer can add them too, inside the vendored module or at the root with the full
module-qualified address. Because `moved` applies to all instances of a `for_each`, two blocks covered ten objects.
Plan output is the contract: a module upgrade is done when the plan has moves only, with no creates, destroys or
surprise updates.

**Prevention.**
- Require `moved` blocks in module release checklists, with a plan test against a v1 state.
- Pin behaviour-affecting inputs explicitly instead of relying on defaults.
- Read the changelog before the plan and compare it to the plan afterwards.
- Run the upgrade plan in CI on a copy of the real state.
