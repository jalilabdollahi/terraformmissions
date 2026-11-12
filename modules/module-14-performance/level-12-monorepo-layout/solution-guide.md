# Walkthrough — Junction Box Monorepo

1. **Target layout.**
   ```
   modules/signal_sheet/        shared library (unchanged)
   components/interlocking/     terraform.tf, main.tf
   components/timetable/        terraform.tf, main.tf
   components/platform-display/ terraform.tf, main.tf
   ```
2. **Per component:** copy the root `terraform.tf`, then write `main.tf` with one
   `module "sheet"` call to `../../modules/signal_sheet`. Use `out_dir = "${path.module}/out"` and the same
   `box` and `lines` as the old call in the root.
3. **Empty the root:** delete the three module calls from `main.tf` (and the file itself). The root
   keeps only `terraform.tf`.
4. **Run each component on its own:** `cd components/timetable && terraform init && terraform apply`.
   Each folder gets its own `terraform.tfstate` and its own `out/timetable.txt`.
5. **Check isolation.** A plan in `components/timetable` no longer reads or locks the interlocking state.
