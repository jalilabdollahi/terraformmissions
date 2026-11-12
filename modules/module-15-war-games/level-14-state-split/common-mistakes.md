# Common mistakes

- **Copying the monolith state file into each new stack and trimming it.** All three stacks then share one lineage and one serial history, and each still carries objects belonging to the others; the first apply in the wrong stack deletes them.
- **Applying a new stack config before moving state.** The scaffolds create their own random IDs, so dock keys, rider capacity and bead series are re-issued while the monolith still holds the originals.
- **Moving `random_id.rig_key` to the same name.** The scaffold declares `random_id.light_key`; the old name in the new state is an orphan, and a new lights key gets generated.
- **Planning krewes before applying warehouse.** The remote-state data source finds no outputs and plan fails with "unsupported attribute"; the fix is the order, not the code.
- **Leaving resource code behind in monolith/.** The state is empty, so the next person to run apply there recreates the entire float warehouse a second time.
