# Common Mistakes

- **Skipping sensitive = true on secrets** — they appear in CI/CD logs, a compliance violation.
- **No prevent_destroy on stateful resources** — a stray destroy wipes production data.
- **No validation on security-sensitive variables** — invalid values reach production undetected.
- **No preconditions on critical paths** — compute errors surface late and with poor error messages.
- **Treating hardening as optional** — these are table stakes for production Terraform configs.