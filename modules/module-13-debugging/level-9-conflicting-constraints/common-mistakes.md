# Common mistakes

- **Lowering the root module to `~> 2.3`.** The conflict goes away, but the root module and the berths module now run an old
  provider (and the validator checks the locked version is 3.6 or newer).
- **Deleting `.terraform.lock.hcl` or running `init -upgrade`.** The lock file does not cause this; the constraints do.
- **Removing the version from the galley module altogether.** That works, but a reusable module should still declare the
  range it supports.
- **Writing `~> 2.3, ~> 3.6`** or similar. Constraints inside one string are ANDed, which is still unsatisfiable.
- **Replacing `random_integer` with a hard-coded number** to avoid the module's dependency.
