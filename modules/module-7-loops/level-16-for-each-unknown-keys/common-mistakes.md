# Common mistakes

- **Using `-target=random_id.run` first.** After applying the random_id the keys are known and the plan
  works, but a fresh checkout fails again and the config is still wrong.
- **Switching to `count`.** It plans, but the instances become `[0]`, `[1]`, `[2]`, and the file names no
  longer follow the sample keys the mission asks for.
- **Hard-coding the run id.** A fixed string makes the plan pass but removes the point of a generated
  run id; the validator compares the files with the live output.
- **Moving the random_id into the key via `keepers`.** `keepers` only controls when the id regenerates;
  the id value is still unknown on the first plan.
