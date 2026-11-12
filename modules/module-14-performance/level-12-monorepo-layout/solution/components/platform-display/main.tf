# Cullen Junction signalling: platform-display (its own root module and state).

module "sheet" {
  source  = "../../modules/signal_sheet"
  box     = "platform-display"
  out_dir = "${path.module}/out"
  lines   = [
    "Platform 2: next train 06:12 to Bramley",
    "Mind the gap at car 3",
  ]
}

output "sheet_path" {
  value = module.sheet.sheet_path
}
