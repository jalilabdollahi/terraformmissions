# Common Mistakes

- **`early_renewal_hours = 0`** — no renewal buffer; certs will expire before replacement.
- **`validity_period_hours` too short** — test values (1h, 24h) accidentally left in production.
- **Not automating apply runs** — `early_renewal_hours` only triggers on `terraform plan/apply`;
  if Terraform is never run, certs will expire regardless of this setting.