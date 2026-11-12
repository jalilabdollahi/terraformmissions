# Common mistakes

- **Renaming the workspace to `production`.** Workspace names are not under your control in this mission
  and other tooling depends on them. Rename the file.
- **Pasting the values into `locals`.** Works for one environment, but the settings files are the point
  and the validator rejects copied values.
- **Using `jsondecode`.** The files are YAML. `jsondecode` fails on `spin_seconds: 412.5`.
- **Fixing the path but not the decode.** The file loads, then every attribute access fails because the
  value is still a string.
- **Duplicating `production.yaml` as `prod.yaml`.** It works, but the old file is now dead weight and will
  drift. Move it.
