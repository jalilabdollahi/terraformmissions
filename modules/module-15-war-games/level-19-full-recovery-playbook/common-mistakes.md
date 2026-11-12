# Common mistakes

- **Starting from `terraform apply`.** With a corrupt or stale state, apply creates a second generator serial and a new fuel figure; with the camp in polar night, nobody can re-stamp equipment.
- **Deleting the state and starting over.** Every ID in the camp is re-rolled; the backup exists for exactly this.
- **Restoring the backup and calling it done.** It predates the fuel tank, so the plan wants to create a new tank figure that disagrees with the manifest and the paperwork.
- **Replacing everything tainted.** The radio key was tainted out of nervousness; replacing it re-issues a key already stamped on the radios. Untaint it, and let only the beacon (whose provisioner genuinely failed) be recreated.
- **Silencing drift with `ignore_changes`.** The manual edit to the radio sheet is wrong; the plan should rewrite the file, not accept it.
- **Fixing the first config error and stopping.** The renamed output hides the type error in the comms module until the first is gone.
