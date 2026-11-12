# Common mistakes

- **Checking `.change.before` for permissions.** For a new file `before` is null; the check silently
  never fires. Policy is about what the file will be, so use `after`.
- **Comparing the actions array to `["delete"]`.** Replacements are `["delete","create"]` and slip
  through; the validator tries both orders.
- **Applying R2 to every `resource_changes` entry.** Existing no-op files and data-source reads have
  other permissions and filenames and must not make the gate fail.
- **Ignoring jq's exit status.** With `2>/dev/null` and no check, a corrupt plan file is "compliant".
- **Hard-coding the sample file names or addresses.** The fixtures use different addresses than the
  workspace; the rules are about attributes, not names.
