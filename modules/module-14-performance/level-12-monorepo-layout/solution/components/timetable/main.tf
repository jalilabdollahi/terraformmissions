# Cullen Junction signalling: timetable (its own root module and state).

module "sheet" {
  source  = "../../modules/signal_sheet"
  box     = "timetable"
  out_dir = "${path.module}/out"
  lines   = [
    "06:12 Cullen Junction to Bramley, platform 2",
    "06:40 Bramley to Cullen Junction, platform 1",
  ]
}

output "sheet_path" {
  value = module.sheet.sheet_path
}
