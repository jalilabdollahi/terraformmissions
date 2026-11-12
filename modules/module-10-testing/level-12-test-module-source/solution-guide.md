# Walkthrough - Mosaic Panel Modules

1. `terraform test` prints, for `tile_area`:
   ```
   Error: Unreadable module directory
   Unable to evaluate directory symlink: lstat ../modules: no such file or directory
   ```
   The author wrote `../modules/tile` as if relative to `tests/`. Module sources in a test file are
   resolved from the working directory of `terraform test`, i.e. the root of the configuration. The path
   is `./modules/tile`.
2. `frieze_area` points to `./modules/friezes`, but the directory is `modules/frieze`. Fix the typo.
3. Run `terraform init` again. Test-file module sources are installed during init, and Terraform otherwise
   answers `Module not installed` after you edit them.
4. `terraform test`: `Success! 3 passed, 0 failed.`
5. `panel_total` tests the root module and needs no `module` block.
