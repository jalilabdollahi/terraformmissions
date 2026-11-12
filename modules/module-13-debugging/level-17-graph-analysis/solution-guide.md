# Walkthrough - Olive Oil Bottling Graph

1. `terraform graph > graph.dot` and read it (or paste it into any Graphviz viewer). In the DOT output
   `"[root] A" -> "[root] B"` means *A depends on B*.
2. Filter to the managed resources: `grep -- '->' graph.dot | grep -v provider`. You will see:
   - `local_file.pressing`, `local_file.cap_order`, `time_sleep.printer_warmup` -> `random_pet.batch`
   - `local_file.labels` -> `time_sleep.printer_warmup`
   - `local_file.manifest` -> `pressing`, `labels`
   - `terraform_data.dispatch` -> `local_file.cap_order` (only!)
3. The last line is the bug: `dispatch` never waits for the manifest, yet the script requires it. On a fresh checkout dispatch starts
   as soon as the cap order is written, so the manifest may not exist: "works if you run it again".
4. Fix: add `depends_on = [local_file.manifest]` to `terraform_data.dispatch` (or reference a manifest attribute in its
   environment).
5. Answers from the fixed graph:
   - the resource with the most arrows pointing at it: `random_pet.batch` (3: pressing, cap_order, printer_warmup),
   - the longest chain: batch -> printer_warmup -> labels -> manifest -> dispatch, which is 5 resources.
   ```
   hub=random_pet.batch
   longest_chain=5
   ```
6. `terraform apply`, `check`.
