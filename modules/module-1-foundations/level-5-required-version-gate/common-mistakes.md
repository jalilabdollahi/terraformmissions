# Common mistakes

- **Deleting the `required_version` line.** Terraform runs, but you have removed the team's version
  guardrail; the mission expects the gate to remain, loosened.
- **Switching to an older Terraform.** The constraint says `< 1.0`; downgrading to 0.x is not an option
  for modern configs, and the lock file and state format would suffer.
- **Writing `required_version = "1.10"`.** An exact pin only admits that exact release; the installed
  one differs, so the gate still fails.
- **Changing `required_providers` instead.** The error is about Terraform Core, not a provider.
