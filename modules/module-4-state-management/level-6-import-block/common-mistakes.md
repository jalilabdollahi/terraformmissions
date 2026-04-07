# Common Mistakes

- **Wrong ID format** — check provider docs for the correct ID format per resource type.
- **`to` address not matching the resource declaration** — the `to` value must exactly reference the declared resource.
- **Forgetting Terraform version** — `import {}` blocks require Terraform >= 1.5.0.