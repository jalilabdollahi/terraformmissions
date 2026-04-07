# Common Mistakes

- **Using .id when .result is the correct attribute** — always check provider documentation.
- **Over-relying on -target** — partial applies can create state drift that accumulates over time.
- **Forgetting that -target includes dependencies** — Terraform will also apply any dependencies of the targeted resource.
- **Not running a full apply after -target** — always follow up with an untargeted apply to converge the full config.