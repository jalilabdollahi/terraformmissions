# Debrief - testing a child module directly

By default, `terraform test` runs each `run` block against the configuration in the current directory.
A `module { source = ... }` block inside a run swaps that target: the run then plans or applies the
referenced module as if it were the root, with its own variables and outputs. This is how you give a small
reusable module its own focused tests without writing a throwaway root configuration around it, and how a
shared module repo can keep its tests next to its code.

Two details cause most failures. First, **path resolution**: relative sources start at the directory where
the command runs, not where the `.tftest.hcl` file sits, so the `../` that feels right from inside `tests/`
is wrong. Second, **installation**: module sources used by test files are recorded when `terraform init`
runs. After editing one you must init again; otherwise Terraform reports the module as not installed even
though the directory exists.

Note also that sources must start with `./` or `../` for local paths. A bare `modules/tile` is read as a
registry address and rejected. Remote sources (registry, Git) work the same way, which lets a test pull a
helper from another repository.

Real-world takeaway: test modules at their own boundary. Give each module a small test file with a
`module` block, test the composition once at the root, and keep sources as short `./` paths so
the test runs the same way from CI as on a laptop.
