# Solution guide

1. `terraform validate` rejects the config with `Invalid File Permission String Value` and
   `bad mode permission: string length should be 3 or 4 digits`. The offenders are the symbolic
   strings `"rwxr-xr-x"` and `"rw-r--r--"`; the bare number `600` is a decimal in disguise and should
   be quoted as well.
2. Edit `main.tf`:
   - `file_permission = "0600"` on the token
   - `directory_permission = "0755"` on the token
   - `file_permission = "0644"` on the manifest
3. `terraform apply`, then `ls -l fleet` should show `-rw-------` for sync.token and `-rw-r--r--` for machines.csv.
