# Common Mistakes

- **Equality check instead of membership check** — `== "production"` vs `contains([...], var.env)`.
- **Forgetting to update the error message** — the message should describe the valid values.
- **Duplicate validation** — if you have a `variable` validation block already, a precondition may be redundant.