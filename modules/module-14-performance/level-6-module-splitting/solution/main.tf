# Tallow and Thyme candle works: three composable modules.

module "pour" {
  source = "./modules/pour"

  batch_prefix = "tt-"
  scent        = "fig and cedar"
}

module "wick" {
  source = "./modules/wick"

  wick_cm = 7
}

module "label" {
  source = "./modules/label"

  batch_code = module.pour.batch_code
  wick_cm    = module.wick.wick_cm
  scent      = "fig and cedar"
}

moved {
  from = module.workshop.random_id.batch
  to   = module.pour.random_id.batch
}

moved {
  from = module.workshop.local_file.pour_sheet
  to   = module.pour.local_file.pour_sheet
}

moved {
  from = module.workshop.local_file.wick_spec
  to   = module.wick.local_file.wick_spec
}

moved {
  from = module.workshop.local_file.label
  to   = module.label.local_file.label
}

output "label_text" {
  value = module.label.label_text
}
