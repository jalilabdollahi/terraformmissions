# Walkthrough — Traffic Light Monorepo

1. **Target layout.**
   ```
   modules/plan_sheet/        shared library (unchanged)
   components/junction-controller/     terraform.tf, main.tf
   components/bus-priority/        terraform.tf, main.tf
   components/crossing-countdown/ terraform.tf, main.tf
   ```
2. **Per component:** copy the root `terraform.tf`, then write `main.tf` with one
   `module "sheet"` call to `../../modules/plan_sheet`. Use `out_dir = "${path.module}/out"` and the same
   `unit` and `lines` as the old call in the root.
3. **Empty the root:** delete the three module calls from `main.tf` (and the file itself). The root
   keeps only `terraform.tf`.
4. **Run each component on its own:** `cd components/bus-priority && terraform init && terraform apply`.
   Each folder gets its own `terraform.tfstate` and its own `out/bus-priority.txt`.
5. **Check isolation.** A plan in `components/bus-priority` no longer reads or locks the junction-controller state.
