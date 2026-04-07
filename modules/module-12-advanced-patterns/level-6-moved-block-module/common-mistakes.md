# Common Mistakes

- **Wrong module label** — the label in `module.X` must match the `module "X"` declaration exactly.
- **Missing intermediate module path** — for nested modules, the full path must be specified: `module.outer.module.inner.resource_type.label`.
- **Omitting the resource type** — the full address includes `module.<label>.<type>.<resource_label>`, not just the resource label.