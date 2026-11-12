# Common mistakes

- **Replacing the ephemeral resource with a regular `random_password` resource.** The error disappears, but the token is now stored in state, which is exactly what the mission forbids.
- **Marking the root module's output ephemeral.** Root modules cannot have ephemeral outputs; Terraform reports *Ephemeral output not allowed in context of a root module*.
- **Wrapping the output value in `nonsensitive()` or `sensitive()`.** Those change display, not persistence; the value is still ephemeral and still rejected.
- **Moving the token into `terraform_data.input`.** `input` is persisted, so Terraform refuses an ephemeral value there.
- **Hard-coding a token in the module.** Nothing is ephemeral then, and the dispatch-box content is a shared secret again.
