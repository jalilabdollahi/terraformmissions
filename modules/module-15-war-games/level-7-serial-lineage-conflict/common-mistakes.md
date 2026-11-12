# Common mistakes

- **`terraform state push -force` of the snapshot.** The push succeeds and resurrects c3's old call-sign and the
  archive index, and the state now carries a different lineage than every other copy.
- **Editing the snapshot's lineage and serial and pushing the whole thing.** The checks pass, the stale c3 and
  archive index come with it, and the next plan wants to destroy and re-roll.
- **Applying first to "see what happens".** Terraform creates a new seal and a new c2 call-sign and rewrites the
  docket files, which destroys the only on-disk record that proves which values are real.
- **Lowering the live serial to match the snapshot.** A serial that moves backwards makes remote backends and
  teammates reject your writes.
- **Importing random values copied from the old snapshot without comparing to docket/.** c3 was re-rolled
  since the snapshot; its old value is wrong.
