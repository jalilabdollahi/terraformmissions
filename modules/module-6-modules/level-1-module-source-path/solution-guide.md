# Walkthrough — Tarndale Clip Labels

1. **Read the init error.**
   ```bash
   terraform init
   # Error: Invalid registry module source address
   #   Failed to parse module registry address: ... "modules/grading"
   ```
   Local paths must begin with `./` or `../`; anything else is parsed as `namespace/name/provider`.
2. **Add the prefix.** `source = "./modules/grading"`, then `terraform init` again.
3. **Read the second error.**
   ```
   Error: Unreadable module directory
   Unable to evaluate directory symlink: lstat ./modules/grading: no such file or directory
   ```
   `ls modules` shows the folder is called `grader`.
4. **Fix the directory name.** `source = "./modules/grader"`.
5. `terraform init && terraform apply`, then `check`.
