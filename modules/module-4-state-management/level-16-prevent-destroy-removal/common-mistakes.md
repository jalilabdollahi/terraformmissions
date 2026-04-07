# Common Mistakes

- **Forgetting prevent_destroy on critical resources** — database clusters, state buckets should have it.
- **Not removing it before intentional destruction** — you must change the code before destroying.
- **Confusion with `ignore_changes`** — `ignore_changes` ignores attribute drift; `prevent_destroy` prevents resource deletion.