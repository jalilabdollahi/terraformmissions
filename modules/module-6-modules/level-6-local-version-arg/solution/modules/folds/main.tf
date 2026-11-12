variable "model" {
  type = string
}

locals {
  library = {
    crane = ["Fold square diagonally", "Unfold and fold other diagonal", "Collapse into a bird base", "Fold flaps to centre", "Pull the wings", "Shape the head"]
    frog  = ["Fold into a waterbomb base", "Fold the front legs", "Fold the back legs", "Press the back to jump"]
  }
  steps = local.library[var.model]
}

resource "local_file" "sheet" {
  filename = "${path.root}/models/${var.model}.txt"
  content  = join("\n", [for i, s in local.steps : "${i + 1}. ${s}"])
}

output "step_count" {
  value = length(local.steps)
}

output "sheet_file" {
  value = local_file.sheet.filename
}
