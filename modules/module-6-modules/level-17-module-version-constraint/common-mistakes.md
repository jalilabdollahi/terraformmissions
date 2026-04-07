# Common Mistakes

- **Using a Git URL for local modules** — unnecessary and fails without internet access.
- **Missing `./` prefix on local paths** — without it, Terraform treats the string as a registry address.