#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record pet "$(tm_state_attr random_pet.store_manager id)"
tm_record aisle "$(tm_state_attr random_string.aisle_code result)"
tm_record lot "$(tm_state_attr random_integer.lot_number result)"
# The intern's mistake: apply a branch where three resources were deleted.
# Terraform saves the previous state as terraform.tfstate.backup, then writes the trimmed one.
cp main.tf "$TM_TMP/main.tf"
# The index keeps its exact text (literal values), so only the three objects leave the state.
cat > main.tf <<HCL
resource "local_file" "inventory_index" {
  filename = "\${path.module}/inventory/index.txt"
  content  = <<-EOT
    Store manager: $(tm_recall pet)
    Aisle code: $(tm_recall aisle)
    Next lot no: $(tm_recall lot)
  EOT
}
HCL
tm_apply
cp "$TM_TMP/main.tf" main.tf
