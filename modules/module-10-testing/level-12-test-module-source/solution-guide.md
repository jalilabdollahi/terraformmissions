# Walkthrough - Quilt Kit Modules

1. `terraform test` prints, for `block_fabric`:
   ```
   Error: Unreadable module directory
   Unable to evaluate directory symlink: lstat ../modules: no such file or directory
   ```
   The author wrote `../modules/block` as if relative to `tests/`. Module sources in a test file are
   resolved from the working directory of `terraform test`, i.e. the root of the configuration. The path
   is `./modules/block`.
2. `border_fabric` points to `./modules/borders`, but the directory is `modules/border`. Fix the typo.
3. Run `terraform init` again. Test-file module sources are installed during init, and Terraform otherwise
   answers `Module not installed` after you edit them.
4. `terraform test`: `Success! 3 passed, 0 failed.`
5. `kit_total` tests the root module and needs no `module` block.
