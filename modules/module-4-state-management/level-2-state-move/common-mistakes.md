# Common Mistakes

- **Missing `filename`** — `local_file` always needs a filename.
- **Wrong address order** — `state mv` takes source first, destination second.
- **Not refreshing config after mv** — after `state mv`, update the resource name in `.tf` files too, or the next plan will show a delete+create.