# Common Mistakes

- **Wrong resource address** — `terraform taint` and `-replace` require the exact address from `terraform state list`.
- **Using deprecated `taint`** — prefer `terraform apply -replace=<address>`.
- **Tainting in production without a plan** — always check `terraform plan` after tainting to understand the blast radius.