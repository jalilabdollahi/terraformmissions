# Mudflat Music Festival: the stage module and what the other teams read from it.

module "stage" {
  source = "./modules/stage"

  stage_id        = "main-stage"
  power_budget_kw = 48
}

output "contract" {
  value = module.stage.stage_contract
}

output "rigging_limit" {
  value = local_file.rigging_limit.content
}
