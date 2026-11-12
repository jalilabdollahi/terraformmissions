# Common mistakes

- **Only changing the condition to `mode == "600"` and leaving the default `"0644"`.** The apply now fails, as it should; the default must be corrected too.
- **Comparing with the Terraform-style string `"0600"`.** The audit script reports plain octal digits (`600`), so the condition never matches and every apply fails.
- **Moving the check into a `precondition`.** It would only see the configured `var.key_mode`, not the mode that is really on disk, and it cannot catch drift.
- **Deleting the audit data source.** The validator needs the postcondition, and `audited_mode` must still read 600.
- **Making the check `!= "644"`.** 0640 and 0660 would still be accepted; the policy is "owner only".
