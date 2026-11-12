# Cullen Junction signalling: interlocking (its own root module and state).

module "sheet" {
  source  = "../../modules/signal_sheet"
  box     = "interlocking"
  out_dir = "${path.module}/out"
  lines   = [
    "Signal 12 holds at danger while points 7 are reversed",
    "Release only after track circuit TC-4 clears",
  ]
}

output "sheet_path" {
  value = module.sheet.sheet_path
}
