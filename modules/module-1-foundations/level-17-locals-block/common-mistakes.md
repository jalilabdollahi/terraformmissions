# Common Mistakes

- **Duplicate keys in `locals`** — each name must be unique within a locals block.
- **Multiple `locals` blocks** — allowed (Terraform merges them), but having duplicates across blocks is still an error.
- **Confusing `local.x` with `var.x`** — locals are referenced with `local.` (no 's'), variables with `var.`.