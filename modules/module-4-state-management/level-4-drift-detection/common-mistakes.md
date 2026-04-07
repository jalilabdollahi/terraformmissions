# Common Mistakes

- **Typo in variable name** — `file_contents` vs `file_content`; Terraform will not autocorrect.
- **Assuming plan exit 0 means "healthy"** — exit 0 means no changes; drift appears as exit 2.
- **Not running refresh** — by default `terraform plan` refreshes state; `-refresh=false` skips this.