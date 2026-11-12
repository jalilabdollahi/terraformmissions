# Debrief — Saltmarsh Tide Card

**What broke.** `required_version` in the `terraform {}` block is a safety gate: Terraform compares
its own version against the constraint before it reads anything else, and refuses to continue if the
version does not match. This one was written for Terraform 0.12 and capped at `< 1.0`, so no 1.x
release can ever satisfy it, and the error appears on *every* command.

**Why teams use the gate.** Terraform's state format and language evolve. Once state is written by
a newer version, older versions refuse to read it. A lower bound (`>= 1.10`) makes sure everybody
uses a version with the features the code needs. An upper bound is rare and risky; it is meant for a
known incompatibility, not as a default. If you want protection from surprise major versions, use
`~> 1.10`, which accepts `1.10` upwards but never `2.0`.

**Gate vs. provider constraints.** `required_version` is about the Terraform CLI. Provider versions are
pinned separately in `required_providers`. Both live in the same block, and both are checked, but at
different moments (`init` for providers; every command for the CLI).

**Real-world takeaway.** Review constraints when you upgrade Terraform, and keep CI, local machines
and any Docker images on versions your gate accepts. A stale upper bound is a build failure
waiting for the next upgrade day.
