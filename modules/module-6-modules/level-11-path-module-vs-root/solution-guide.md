# Walkthrough — Hollow Lane Audio Guide

1. **Plan.** The first failure is `Invalid function argument ... no file exists at "./templates/narration.tpl"`.
   From the root, `path.root` is `.`, and there is no `templates/` folder there.
2. **Swap the template reference** to `path.module` (resolves to `modules/guide`), where `templates/narration.tpl` lives.
3. **Apply and look at the output.** The script is created at `modules/guide/audio/haunted-cellar.txt` because the
   `filename` uses `path.module`. Walkers' scripts belong in the workspace, so use `path.root` there; delete the stray
   file (Terraform removes it when the filename changes).
4. Run `terraform apply` once more, then `check`.
