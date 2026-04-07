# Common Mistakes

- **Missing scheme** — `example.com/api` is not valid; write `https://example.com/api`.
- **HTTP vs HTTPS** — some providers or endpoints only accept `https://`.
- **Not declaring the `http` provider** — the `hashicorp/http` provider must be listed in `required_providers`.