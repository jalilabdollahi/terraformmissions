# Hollis Orchard crate manifest.
# One workspace per harvest.

locals {
  harvest = "terraform.workspace"
  crates  = ["apples", "pears", "quince"]
}

resource "local_file" "manifest" {
  filename = "${path.module}/out/${local.harvest}-crates.txt"
  content  = "Harvest: {terraform.workspace}\n${join("\n", [for c in local.crates : "crate ${c}"])}\n"
}

output "crate_label" {
  value = format("%s-%d", "terraform.workspace", length(local.crates))
}
