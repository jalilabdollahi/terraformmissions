# Debrief — only some tfvars files load by themselves

Variable definitions files are the usual way to supply environment-specific values, and Terraform
has a short list of file names it picks up on its own:

1. `terraform.tfvars`
2. `terraform.tfvars.json`
3. any `*.auto.tfvars` or `*.auto.tfvars.json`, in lexical order

Everything else — `prod.tfvars`, `staging.tfvars`, `env/winter.tfvars` — is inert unless you pass
`-var-file=...` explicitly. Terraform does not warn about the unused file, because from its point of
view it is not part of the configuration at all. The nightly job simply runs with the defaults, and the
mistake surfaces as "the guests were lukewarm".

Two good designs:
- **One workspace/directory per environment** with its own `terraform.tfvars` (or `*.auto.tfvars`).
- **Shared code, explicit var-files**: keep `prod.tfvars`, `dev.tfvars`, and make the pipeline always
  say `terraform plan -var-file=prod.tfvars`. Then never put anything environment-specific in an
  auto-loaded file.

Mixing the two (an auto-loaded file *and* an explicit one) leads to the precedence puzzles in the next
lesson, so choose one.

## Real-world takeaway

If values "silently don't apply", print what Terraform actually sees: check the plan, and for
variables use `terraform console` + `var.name`. Do not assume a file is loaded because it sits in the
directory.
