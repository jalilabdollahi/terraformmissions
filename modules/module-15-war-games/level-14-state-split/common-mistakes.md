# Common mistakes

- **Copying the monolith state file into each new stack and trimming it.** All three stacks then share one lineage and one serial history, and each still carries objects belonging to the others; the first apply in the wrong stack deletes them.
- **Applying a new stack config before moving state.** The scaffolds create their own random IDs, so hall keys, seat capacity and pass series are re-issued while the monolith still holds the originals.
- **Moving `random_id.cdn_key` to the same name.** The scaffold declares `random_id.stream_key`; the old name in the new state is an orphan, and a new stream key gets generated.
- **Planning ticketing before applying venue.** The remote-state data source finds no outputs and plan fails with "unsupported attribute"; the fix is the order, not the code.
- **Leaving resource code behind in monolith/.** The state is empty, so the next person to run apply there recreates the entire opera house a second time.
