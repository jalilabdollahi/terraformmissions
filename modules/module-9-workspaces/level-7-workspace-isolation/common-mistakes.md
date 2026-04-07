# Common Mistakes

- **Fixed filenames across workspaces** — always suffix resource identifiers with the workspace name.
- **Assuming workspaces are fully isolated** — only the state is isolated; physical resources (files, cloud objects) are NOT automatically separated.
- **Forgetting the workspace in remote resource names** — cloud resource names (S3 buckets, DNS records) must also be unique per workspace.