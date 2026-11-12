# Walkthrough — Compass Rose Proof

1. **Reproduce.** `terraform apply`, then `terraform plan` without touching anything. The plan
   says `local_file.proof must be replaced` and lists `content` / `content_sha256` going to
   "known after apply". An immediately-clean plan is what a healthy config gives you.
2. **Diagnose.** `art/compass-rose.png` is binary (it starts with the bytes `\x89PNG`). The
   `.content` attribute is a string; the bytes that are not valid UTF-8 get mangled once the value
   is stored in state, so state and config never agree.
3. **Fix.** Use the base64 pair on both sides:
   ```hcl
   resource "local_file" "proof" {
     filename       = "${path.module}/press/rose-proof.png"
     content_base64 = data.local_file.rose.content_base64
   }
   ```
4. `terraform apply`, check with `cmp art/compass-rose.png press/rose-proof.png` (no output means
   identical), run `terraform plan` (no changes), then type `check`.
