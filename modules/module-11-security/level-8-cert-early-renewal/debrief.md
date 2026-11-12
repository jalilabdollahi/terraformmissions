# Debrief — expiry should be a scheduled event, not an outage

Certificates that expire silently are one of the most common causes of production incidents. The `tls` provider has two knobs to turn
expiry into something Terraform handles for you. `validity_period_hours` is the lifetime of the certificate being issued;
`early_renewal_hours` defines a window before expiry in which the resource is considered "ready for renewal", so the next `terraform plan`
shows a replacement and the next `apply` issues a fresh certificate (and a fresh PEM file written by anything that references it).

Notice the relationship: the window must be shorter than the validity. If it is not, the certificate is inside its renewal window from the very
moment it is created, and every plan wants to replace it.

Terraform only renews when someone runs it. A renewal window of two weeks is worth little if the pipeline runs once a quarter, so match the window to your apply cadence — and add monitoring (such as `-checkend` in a cron job)
as a second line of defence. For publicly trusted certificates use an ACME-based tool, not self-signed certificates; this pattern fits internal and test certificates where Terraform is the issuer.
