# Common mistakes

- **Deleting .terraform.lock.hcl and running init again.** The new file again holds only this machine's
  checksum, and you also lose the version pin.
- **Running `terraform init -upgrade`.** It may change the provider version and still records only the
  local platform.
- **Adding `-platform=darwin_amd64` to the command.** The vendored mirror has no package for it and
  the command fails; that platform is already in the file.
- **Copying hashes from another project's lock file.** Hashes are per provider version and package;
  pasting one you did not obtain from the package itself defeats the control.
- **Using `providers lock` without `-fs-mirror` in the pit garage.** It tries the registry, and there is no
  network.
