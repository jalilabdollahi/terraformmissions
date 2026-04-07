# Common Mistakes

- **Assuming Terraform infers file-path dependencies** — it doesn't; only attribute references are tracked.
- **Using `depends_on` everywhere** — overuse can create hidden coupling; only use it when truly needed.
- **Forgetting that `depends_on` defers the data source read** — the data source will be re-read during apply, not plan.