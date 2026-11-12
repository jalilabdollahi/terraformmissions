# Common mistakes

- **Pasting the token into a `.tf` file or `terraform.tfvars`.** The pipeline goes green, and the secret is now in git history and in the state file. The ticket says env var or the git-ignored file.
- **Taking the sandbox token because it is "valid".** The signature checks out, but the production registry refuses it (code 44), and the log says so in plain words.
- **Stopping after the credential error.** The next run is refused for the region (`north_sea` vs `north-sea`); the first log line is rarely the only one.
- **Editing `bin/quota_lookup.py` to skip the check or hard-coding `tonnes`.** The quota is a registry fact; bypassing the lookup turns an outage into silently wrong permits.
- **Running `terraform untaint` on the stamp.** The object exists, but out/permit-stamp.txt still says `STAMP INCOMPLETE`; only a replace re-runs the provisioner.
- **`terraform apply -replace` on the vessel key as well.** It re-issues the key printed on the vessel's paperwork.
