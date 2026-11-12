#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record pet "$(tm_state_attr random_pet.head_librarian id)"
tm_record shelf "$(tm_state_attr random_string.shelf_code result)"
tm_record card "$(tm_state_attr random_integer.card_number result)"
# The intern's mistake: apply a branch where three resources were deleted.
# Terraform saves the previous state as terraform.tfstate.backup, then writes the trimmed one.
cp main.tf "$TM_TMP/main.tf"
# The index keeps its exact text (literal values), so only the three objects leave the state.
cat > main.tf <<HCL
resource "local_file" "catalog_index" {
  filename = "\${path.module}/catalog/index.txt"
  content  = <<-EOT
    Head librarian: $(tm_recall pet)
    Shelf code: $(tm_recall shelf)
    Next card: $(tm_recall card)
  EOT
}
HCL
tm_apply
cp "$TM_TMP/main.tf" main.tf
