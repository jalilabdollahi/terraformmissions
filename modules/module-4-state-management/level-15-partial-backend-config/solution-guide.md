# Walkthrough — Signal Tower Backend

1. **Try the init.**
   ```bash
   terraform init -backend-config=config/backend-prod.hcl
   # Error: Unsupported argument
   #   on config/backend-prod.hcl line 2: file_path = ...
   # An argument named "file_path" is not expected here.
   ```
2. **Fix the file.** The local backend's argument is `path`:
   ```hcl
   path = "state/signal-tower.tfstate"
   ```
3. **Init again.** The workspace was already initialised with the default location, so Terraform reports a backend
   change. The default state is empty, so `-reconfigure` is the right choice:
   ```bash
   terraform init -reconfigure -backend-config=config/backend-prod.hcl
   ```
4. `terraform apply`, then `ls state/` shows `signal-tower.tfstate`. Type `check`.
