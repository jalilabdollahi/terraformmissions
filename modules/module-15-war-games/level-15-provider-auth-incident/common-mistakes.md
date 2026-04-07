# Common Mistakes

- **Variable name mismatch** — declaring `api_secret` but referencing `api_key` is surprisingly common.
- **Not using terraform validate before plan** — validate catches undefined variables immediately.
- **Hardcoding credentials in provider block** — always use variables or environment variables.
- **Case sensitivity issues** — `API_Key` vs `api_key` — variable names are case-sensitive.