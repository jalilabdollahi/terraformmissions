#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record pet "$(tm_state_attr random_pet.sales_manager id)"
tm_record bay "$(tm_state_attr random_string.bay_code result)"
tm_record stock "$(tm_state_attr random_integer.stock_number result)"
# The intern's mistake: apply a branch where three resources were deleted.
# Terraform saves the previous state as terraform.tfstate.backup, then writes the trimmed one.
cp main.tf "$TM_TMP/main.tf"
# The index keeps its exact text (literal values), so only the three objects leave the state.
cat > main.tf <<HCL
resource "local_file" "stock_index" {
  filename = "\${path.module}/stock/index.txt"
  content  = <<-EOT
    Sales manager: $(tm_recall pet)
    Bay code: $(tm_recall bay)
    Next stock no: $(tm_recall stock)
  EOT
}
HCL
tm_apply
cp "$TM_TMP/main.tf" main.tf
