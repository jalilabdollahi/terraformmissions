# Walkthrough — Seals Of The Salt Road

1. `terraform validate` reports `Invalid for_each argument ... Sensitive values, or values derived from
   sensitive values, cannot be used as for_each arguments`. Resource instance keys appear in plan output and in state
   addresses, so Terraform will not let a secret become a key.
2. The second error is `Output refers to sensitive values`: `sha256(token)` is still derived from a secret, so
   the sensitivity travels through every function call. The output must be `sensitive = true`.
3. Fix by separating identity from secret:
   ```hcl
   variable "post_names"  { type = set(string) default = ["petra","merv","palmyra"] }
   variable "seal_tokens" { type = map(string) sensitive = true }
   resource "local_sensitive_file" "seal" {
     for_each = var.post_names
     content  = var.seal_tokens[each.key]
     ...
   }
   ```
4. Add `sensitive = true` to `seal_digests`. Supply the tokens with `TF_VAR_seal_tokens='{"petra":"..."}'`
   when you test by hand, then type `check`.
