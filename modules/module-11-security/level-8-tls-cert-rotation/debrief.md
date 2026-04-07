# TLS Certificate Expiring Too Fast

## What Was Broken
`validity_period_hours = 1` creates a cert that expires in one hour. `early_renewal_hours = 0`
means Terraform will not proactively renew it before expiry. Together, these settings guarantee
an outage on any service using this certificate.

## Recommended Values

| Use Case             | validity_period_hours | early_renewal_hours |
|----------------------|-----------------------|---------------------|
| Production server    | 8760 (1 year)         | 168 (1 week)        |
| Dev/test             | 2160 (90 days)        | 48 (2 days)         |
| Short-lived service  | 720 (30 days)         | 24 (1 day)          |

## How early_renewal_hours Works
When `terraform plan` or `terraform apply` runs and the cert has fewer than `early_renewal_hours`
remaining, Terraform marks it for replacement. This allows automated pipelines to renew certs
proactively before they expire.

## Why It Matters
An expired TLS certificate causes immediate service outages and browser security warnings.
Proper renewal windows ensure continuous service availability.