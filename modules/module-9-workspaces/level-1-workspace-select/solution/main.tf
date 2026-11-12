# Willowbank pitch preparation. One workspace per environment.
# The plan file name carries the workspace name so environments never share output.

locals {
  areas = ["Main Square", "Practice Nets", "Outfield"]
}

resource "local_file" "groundsman_plan" {
  filename = "${path.module}/out/${terraform.workspace}-groundsman-plan.txt"
  content  = "Pitch preparation plan for ${terraform.workspace}\n${join("\n", [for p in local.areas : "- ${p}"])}\n"
}

output "plan_file" {
  value = local_file.groundsman_plan.filename
}
