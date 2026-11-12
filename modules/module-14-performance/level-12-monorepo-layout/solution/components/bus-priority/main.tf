# Mapleton Crossroads traffic lights: bus-priority (its own root module and state).

module "sheet" {
  source  = "../../modules/plan_sheet"
  unit    = "bus-priority"
  out_dir = "${path.module}/out"
  lines   = [
    "06:12 Route 9 to Eastgate: green extension 8s",
    "06:40 Route 9 to Mapleton: green extension 8s",
  ]
}

output "sheet_path" {
  value = module.sheet.sheet_path
}
