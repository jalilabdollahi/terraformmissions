# Common mistakes

- **Keeping `-parallelism=1`.** The slip may happen to run last on your machine, but the bug is still
  in the code; the validator rejects any parallelism setting.
- **Adding `sleep 2` (or a wait loop) to the command.** Wall-clock guesses fail on a slow runner and
  slow every apply down; the ordering should be a dependency instead.
- **Re-running apply until it passes.** The second run succeeds because the ledger now exists in
  state, which hides the bug from the first run on a fresh environment.
- **Putting `depends_on` on the wrong side.** `depends_on = [terraform_data.casting_slip]` inside the
  ledger creates a cycle-free but backwards order: the slip then still runs first.
