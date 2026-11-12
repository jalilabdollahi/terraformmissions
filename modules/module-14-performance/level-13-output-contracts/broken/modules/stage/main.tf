# Stage team module.

resource "local_file" "stage_plot" {
  filename = "${path.root}/rigs/stage-plot.txt"
  content  = "Stage ${var.stage_id}: ${var.power_budget_kw} kW available\n"
}

# After the tidy-up: loose outputs, no version, old name gone.
output "stage_id" {
  value = var.stage_id
}

output "power_budget_kw" {
  value = var.power_budget_kw
}
