# Stage team module.

resource "local_file" "stage_plot" {
  filename = "${path.root}/rigs/stage-plot.txt"
  content  = "Stage ${var.stage_id}: ${var.power_budget_kw} kW available\n"
}

# The contract: one versioned object. Add fields in minor versions, never rename or remove within a major.
output "stage_contract" {
  value = {
    version         = var.contract_version
    stage_id        = var.stage_id
    power_budget_kw = var.power_budget_kw
  }
}

# Legacy name, kept for the rigging team until they migrate.
output "power_kw" {
  value      = var.power_budget_kw
  deprecated = "Use stage_contract.power_budget_kw; power_kw will be removed in contract 3.0."
}
