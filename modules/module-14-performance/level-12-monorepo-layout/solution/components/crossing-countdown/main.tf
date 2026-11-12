# Mapleton Crossroads traffic lights: crossing-countdown (its own root module and state).

module "sheet" {
  source  = "../../modules/plan_sheet"
  unit    = "crossing-countdown"
  out_dir = "${path.module}/out"
  lines   = [
    "Crossing 2: walk signal in 12 seconds",
    "Mind the cyclists in the bike lane",
  ]
}

output "sheet_path" {
  value = module.sheet.sheet_path
}
