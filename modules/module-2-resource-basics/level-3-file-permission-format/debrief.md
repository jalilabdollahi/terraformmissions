# Debrief: permissions are octal strings

The `local` provider hands `file_permission` to the operating system as an octal mode, so it expects a
string of 3 or 4 octal digits: `"0600"`, `"0644"`, `"0755"`. Two things went wrong here:

- symbolic modes (`"rw-r--r--"`, `"rwxr-xr-x"`) are `ls -l` notation, which the provider does not
  parse. Terraform reports `bad mode permission: string length should be 3 or 4 digits`;
- the bare number `600` was a trap of a different kind. HCL happily converts it to the string `"600"`,
  so it slips through today, but it is a decimal number in disguise: `file_permission = 0600` and
  `0644` only work by accident of the conversion, and values with a leading 0 or digits above 7 are
  silently wrong. Always quote the mode so it reads exactly like chmod's argument.

`local_sensitive_file` is the right resource for secrets: it behaves like `local_file` but marks its
content sensitive, so it never appears in plan output. It is still stored in plaintext in the state
file, so the state itself needs protecting. Note also that `directory_permission` only applies to
directories Terraform creates, and the directory was created together with the first file in it.

Real-world takeaway: SSH keys, kubeconfigs and agent tokens are routinely rejected by tools when their
modes are too open. Setting the mode in the resource keeps the guarantee in code instead of in a
wiki page.
