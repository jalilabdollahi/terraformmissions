# Common mistakes

- **Renaming the folder from `labels` to `label`.** It silences the error, but the mission is
  about fixing the configuration, and other tooling expects `labels/`.
- **Deleting `label-draft.tmp`.** The zip is clean today, but the next draft label brings the
  problem back; the validator creates a new `.tmp` file to check.
- **Using a glob such as `excludes = ["*"]`.** It excludes the whole archive.
- **Keeping `output_base64sha256` and "converting" it by hand.** The attribute for hex already
  exists; hand conversion is error-prone.
- **Setting `output_path` inside `labels/`.** The archive would contain a stale copy of itself.
