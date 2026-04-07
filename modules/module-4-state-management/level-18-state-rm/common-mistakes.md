# Common Mistakes

- **Wrong resource type** — always check provider documentation for the exact resource type name.
- **Confusing state rm with destroy** — `state rm` does NOT delete the real resource.
- **Using state rm on the wrong address** — verify with `terraform state list` first.