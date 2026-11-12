# Mapleton Crossroads traffic lights: junction-controller (its own root module and state).

module "sheet" {
  source  = "../../modules/plan_sheet"
  unit    = "junction-controller"
  out_dir = "${path.module}/out"
  lines   = [
    "Signal 12 holds red while the tram crossing is active",
    "Release only after loop detector LD-4 clears",
  ]
}

output "sheet_path" {
  value = module.sheet.sheet_path
}
