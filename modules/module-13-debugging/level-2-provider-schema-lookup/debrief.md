# Debrief - the schema is the documentation

Every provider ships a machine-readable schema, and Terraform loads it on every run. That schema decides what
`terraform validate` accepts, so it is, by definition, the truth about which arguments exist, which are required, what
type each has and which are computed-only. `terraform providers schema -json` prints exactly that data for the
provider versions your lock file selected.

That last part matters. Blog posts and AI-generated snippets usually describe the newest provider, or an older one,
or a different provider with a similar resource. The schema in front of you describes the version you are *really*
running. Three habits come out of that:

- Treat "Unsupported argument" as a lookup problem, not a guessing game. Search the JSON for the keyword you remember
  (`jq 'paths | select(.[-1]=="special_chars")'` finds nothing, which already tells you something).
- Check the `computed`/`optional` flags before you add an argument. A computed-only attribute can be read but never set.
- `terraform providers schema` works offline once `terraform init` has run, which makes it the right tool on an air-gapped
  build agent.

The three mistakes in this level are classic cross-provider confusion: `special_chars` sounds right but the
`random` provider calls it `special`; the `local` provider says `file_permission` everywhere; and `time_offset` counts
`offset_days`, not `days`. Save the schema JSON in a scratch folder (never commit it) whenever you start work with an
unfamiliar provider.
