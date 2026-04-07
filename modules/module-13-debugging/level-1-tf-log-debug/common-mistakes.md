# Common Mistakes

- **Using a custom registry path by accident** — short-form `hashicorp/local` expands to `registry.terraform.io/hashicorp/local`.
- **Forgetting that `TF_LOG` output goes to stderr** — pipe with `2>&1` to capture it.
- **Leaving `TF_LOG=DEBUG` set permanently** — it is very noisy; unset it after debugging.