# Common Mistakes

- **Negation logic errors** — `!= "production"` blocks production, not protects it.
- **Incomplete allowlists** — forgetting aliases (`"prod"`, `"prd"`, `"PRODUCTION"`) that operators
  might use.
- **Missing both variable validation and precondition** — use both for defence in depth in
  security-critical resources.