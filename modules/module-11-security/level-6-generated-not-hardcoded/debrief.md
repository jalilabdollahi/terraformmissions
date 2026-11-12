# Debrief — generate secrets, do not author them

A credential typed into source control is a shared secret with no owner, no expiry and no audit trail. Everyone who has ever cloned
the repo can read it, and rotating it means a code change. The `random_password` resource turns that around: Terraform
creates the value once, keeps it in state as a sensitive attribute, and lets other resources consume it by reference.

Compared with `random_string`, `random_password` marks its `result` sensitive so it is redacted from plans and
outputs. The character-class arguments (`min_lower`, `min_upper`, `min_numeric`, `min_special`) let you satisfy a policy deterministically instead
of hoping a random draw contains a digit.

There is a trade-off to remember: the value now lives in the state file. Terraform masks it in the CLI, but state is plaintext JSON, so the state
backend needs encryption and tight access, and anything downstream (here, the radio config file) must itself be created with restrictive permissions —
hence `local_sensitive_file` with mode 0600. Later missions in this module show how to control when the password rotates and how to keep values out of state altogether
with ephemeral resources.
