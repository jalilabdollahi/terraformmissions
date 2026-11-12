# Walkthrough — Dunlin Field Key Audit

1. After `terraform apply`, `ls -l tower/logbook-signing.key` shows `-rw-r--r--`, and `terraform output audited_mode` prints `644`. The audit saw it, and approved.
2. The postcondition inside `data "external" "key_audit"` is `self.result.exists == "true"`. A postcondition runs *after* the object is read or created, and can inspect
   `self`: here the audit result produced by the script.
3. Tighten it to describe the policy: `self.result.exists == "true" && self.result.mode == "600"`. The `mode` value is a string of octal digits.
4. With only the condition changed, apply now fails with *Resource postcondition failed* — correct, because the default `key_mode` is still `"0644"`. Change the default to `"0600"` and apply again.
5. Type `check`. The validator tries `0644`, `0640` and `0660` in a throwaway copy and expects each to be refused.
