# Post-mortem — Pellham Docket Lineage Clash

**Timeline.** 07:30 a cleanup session ran several `terraform state rm` commands against the wrong addresses.
07:45 the seal and c2's call-sign were missing; `terraform plan` offered to invent new ones. 08:00 a clerk's
laptop copy was found; `state push` rejected it on lineage, then on serial. 08:20 the team learned why forcing
would be worse than the original damage. 08:50 a merged state was pushed with the original lineage.

**Root causes.**
1. State surgery without a backup copy taken first.
2. A snapshot kept outside the pipeline went stale silently: one value was re-rolled, one resource retired.
3. A re-initialised copy has a new lineage; Terraform treats it as an unrelated state.

**How Terraform protects you.** `lineage` is the identity of a state history; `serial` is the monotonically
increasing write counter within it. `state push` refuses to overwrite a state with an unrelated lineage or a
non-newer serial, because either means the file did not descend from what it is replacing. `-force` disables both
checks, so using it means you have personally verified the content.

**Lessons.** A restore is a merge, not a copy. Treat every old snapshot as evidence, compare it against the
real world (the filed documents here) and take only the objects you can prove are still correct. Keep the lineage
so that every other copy and CI cache stays on the same history, and move the serial forward.

**Prevention.**
- Snapshot state automatically before any manual surgery.
- Use a remote backend with versioning so "the laptop copy" is not the only copy.
- Pair on `state rm`; prefer `removed` blocks, which are reviewed in a pull request.
