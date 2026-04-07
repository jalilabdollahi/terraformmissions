# Common Mistakes

- **Forgetting `sensitive = true` on outputs** — if the value comes from a sensitive variable, the output must be sensitive.
- **Assuming `sensitive` on a variable hides everything** — it only applies to Terraform's display; data may still be written to state.