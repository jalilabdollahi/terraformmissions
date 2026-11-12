# Walkthrough — Scrapyard Identity Split

1. **Create core/** with its own `terraform.tf` (random provider) and `main.tf` holding
   `random_pet.yard_name`, `random_integer.gate_count` and outputs `yard_name`, `gate_count`.
   Run `terraform -chdir=core init`.
2. **Edit the root config.** Delete the two resources, add
   ```hcl
   data "terraform_remote_state" "core" {
     backend = "local"
     config  = { path = "${path.module}/core/terraform.tfstate" }
   }
   ```
   and point `crane_roster` (and the `yard_name` output) at
   `data.terraform_remote_state.core.outputs.*`.
3. **Move the objects** (before any apply, otherwise Terraform destroys them):
   ```bash
   terraform state mv -state-out=core/terraform.tfstate random_pet.yard_name random_pet.yard_name
   terraform state mv -state-out=core/terraform.tfstate random_integer.gate_count random_integer.gate_count
   ```
4. **Record the outputs.** `terraform -chdir=core apply` shows `0 added, 0 changed, 0 destroyed` and
   writes the outputs the root will read.
5. **Apply the root.** `terraform apply` finds the roster unchanged. Both `terraform plan` and
   `terraform -chdir=core plan` say *No changes*.
