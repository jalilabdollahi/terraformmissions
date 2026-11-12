# Walkthrough — Night Taxi Dispatch Hand-off

1. `terraform plan` stops with *Ephemeral value not allowed* on `output "session_token"` in `modules/issuer/main.tf`:
   *This output value is not declared as returning an ephemeral value, so it cannot be set to a result derived from an ephemeral value.*
2. `ephemeral "random_password"` produces a value that exists only for the duration of the run. Output values are normally persisted, so Terraform will not let an
   ephemeral result flow into one — unless the output itself is declared ephemeral.
3. Add `ephemeral = true` to the child module's output:
   ```hcl
   output "session_token" {
     value     = ephemeral.random_password.session.result
     ephemeral = true
   }
   ```
4. The root module may use that value in the provisioner `environment` (an ephemeral-safe place). Note that a *root* module cannot declare ephemeral outputs,
   and `terraform_data.input` could not hold the token either.
5. Apply and type `check`. The validator reads the token from the dispatch box and searches the state for it.
