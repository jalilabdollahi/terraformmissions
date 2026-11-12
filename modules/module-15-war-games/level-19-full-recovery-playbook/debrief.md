# Post-mortem - midnight-sun recovery

**Timeline.** 18:30 the fuel tank is registered and applied. 18:31 the laptop disk fills during the state write; the file is
truncated. 19:10 a colleague taints the radio key and the dailies and hand-edits the radio sheet. 19:30 the pipeline is blocked
by a refactor that renamed a module output.

**Root causes.**
1. A single local state file on a laptop with a nearly full disk: nothing is atomic across a full disk, and there was no
   remote copy.
2. The on-disk backup is only one write old, so it lost the one object created in the last apply.
3. Four independent mistakes compounded: corrupt state, a configuration cascade (a renamed output broke `comms`, which broke the
   manifest), an unnecessary taint, and manual drift.

**How Terraform behaves.** The state JSON must parse before anything else works, which fixes the triage order: state, then
configuration, then plan. `terraform.tfstate.backup` is the previous revision, not the latest one. Imports re-adopt anything
the backup does not know, provided you can recover the real attributes (here from a rendered manifest). Taint only schedules a
replacement; `untaint` cancels it, while an object whose provisioner really failed should stay tainted so it is rebuilt. Drift
on a `local_file` is corrected by a replace, which is intended.

**Prevention.**
- Store state remotely with versioning and locking; if local, keep copies off the disk that can fill.
- Treat module outputs as an interface: rename with a deprecation period and run `terraform validate` on every PR.
- Decide taint and replace explicitly from evidence (logs, files), never as a precaution.
- Write recovery orders down: state, config, then the plan, with a backup before each step.
