# Debrief - green is not the same as done

`on_failure = continue` tells Terraform to carry on when a provisioner exits non-zero. The apply prints a warning, marks the
resource as successfully created, and exits 0. Pipelines that only check the exit code (nearly all of them) turn green. The work
the provisioner was supposed to do never happened, and Terraform believes it did.

This level shows the two consequences that make it so nasty:

- **The failure is invisible later.** There is no tainted flag, no diff, no error on the next plan. The state says
  the resource is fine.
- **Fixing the script does not re-run it.** Provisioners run only when the object is created or destroyed. After you repair the cause, you
  have to make Terraform create the object again: `terraform apply -replace=ADDRESS`, a changed `triggers_replace`,
  or the older `taint`.

Guidance:

- Use `on_failure = continue` only for work that is truly optional (a courtesy notification), never for the step the
  resource exists to perform.
- Prefer real resources to provisioners when a provider exists. The HashiCorp documentation calls provisioners a last resort.
- Give provisioner scripts strict exit codes, and make your CI check the apply log for `Warning: ... provisioner error` if you must
  keep `continue` somewhere.

A quick audit of any codebase: `grep -rn "on_failure" .` and ask of each hit, "what silently stops happening if this fails?".
