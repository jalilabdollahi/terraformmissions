# Debrief — Thistledown Apiary

**What broke.** The `required_providers` block maps a *local name* (`local`) to a *source address*
(`hashicorp/localfile`). The source address is the provider's real identity: `[hostname/]namespace/type`,
where the hostname defaults to `registry.terraform.io`. `hashicorp/localfile` does not exist, so
`terraform init` has nothing to download and every later command fails with "Inconsistent dependency
lock file" or "Missing required provider".

**Local name vs. type.** The local name before the `=` is only a label inside your module; Terraform
uses it to match resource prefixes (`local_file` belongs to the local name `local`). The *type* at the end of
the source (`.../local`) is the part that must exist in the registry. People often invent a more
descriptive type name such as `localfile` or `random-provider`, which fails.

**How to check.** Search the Terraform Registry (or `terraform providers`, once it works) for the exact
namespace and type. For official providers the namespace is `hashicorp`; third-party ones use the
publisher's name.

**Real-world takeaway.** Provider typos break `init`, not `plan`, so they appear in the first
minute of a CI job. Commit `.terraform.lock.hcl`: it records the exact provider source, version, and
checksums, so everyone on the team resolves the same package. If you ever see a surprising source
address in a pull request diff, treat it as a supply-chain question, not just a typo.
