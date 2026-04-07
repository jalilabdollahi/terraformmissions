# Common Mistakes

- **Missing `./` prefix** — `source = "modules/hello"` (no leading `./`) is interpreted as a registry address, not a local path.
- **Wrong relative level** — `../` goes up one directory; only use it if the module really is a sibling of the root.
- **Forgetting `terraform init`** — changing `source` requires re-running `terraform init`.