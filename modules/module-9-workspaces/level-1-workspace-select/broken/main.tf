# Kestrel Peak piste grooming. One workspace per environment.
# The plan file name carries the workspace name so environments never share output.

locals {
  pistes = ["Eagle Run", "Lower Bowl", "Cedar Glade"]
}

resource "local_file" "groomer_plan" {
  filename = "${path.module}/out/${terraform.workspace}-groomer-plan.txt"
  content  = "Grooming plan for ${terraform.workspace}\n${join("\n", [for p in local.pistes : "- ${p}"])}\n"
}

output "plan_file" {
  value = local_file.groomer_plan.filename
}
