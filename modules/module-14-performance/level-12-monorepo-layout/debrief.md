# Debrief — one root per blast radius

A monorepo of Terraform usually settles on the same shape: a **library** of reusable modules
(`modules/`) and many small **root modules** (`components/`, `stacks/`, `live/`) that call them. The
root module is the unit that has a state, a lock, a plan and an apply. Making each component its own
root gives you:

- **Speed**: a plan refreshes only that component's resources, not the whole estate.
- **Safety**: a bad apply or a corrupted state affects one subsystem; the interlocking state is not
  locked while someone edits the timetable.
- **Ownership**: CODEOWNERS and CI paths line up with directories, so each team reviews and deploys its own.

The costs are real. Components cannot reference each other's resources; they share data through
outputs (remote state or a lookup), and ordering becomes a deployment concern. Duplication moves into
the callers, so keep `terraform.tf` and provider settings small and boring, and keep the library
versioned (relative paths in one repo are fine; tag releases if separate repositories use them).

Rules of thumb: split when two parts change at different rates, are owned by different people, or
have different risk. Do not split every resource; a root with two resources is overhead.

Real-world takeaway: put the shared logic in modules, the deployable units in components, and give each
component a state of its own so that a plan answers "what will change here?" and nothing else.
