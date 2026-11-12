# Common mistakes

- **Adding `sleep 5` to the script or the command.** It hides the race on a fast machine and fails again on a slow runner.
- **Using `terraform apply -parallelism=1`.** It orders only the way the engine happens to walk the graph; it is not a dependency, and it is not in the config.
- **Reading arrows backwards.** In DOT output `A -> B` means A *depends on* B, so the hub is the node on the right of many arrows.
- **Counting edges that do not exist any more** (the default graph is transitively reduced, so redundant arrows are not drawn) or counting
  `provider[...]` and `(close)` nodes. Only the managed resources count.
- **Moving the manifest check into `on_failure = continue`.** The failure gets hidden, not fixed.
