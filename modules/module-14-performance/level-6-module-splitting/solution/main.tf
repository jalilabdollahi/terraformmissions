# Wax & Wonder crayon factory: three composable modules.

module "pour" {
  source = "./modules/pour"

  batch_prefix = "ww-"
  shade        = "sunset orange"
}

module "colour" {
  source = "./modules/colour"

  pigment_pct = 7
}

module "label" {
  source = "./modules/label"

  batch_code = module.pour.batch_code
  pigment_pct = module.colour.pigment_pct
  shade      = "sunset orange"
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
  from = module.workshop.local_file.colour_spec
  to   = module.colour.local_file.colour_spec
}

moved {
  from = module.workshop.local_file.label
  to   = module.label.local_file.label
}

output "label_text" {
  value = module.label.label_text
}
