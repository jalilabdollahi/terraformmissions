# Wax & Wonder crayon factory.
# One module does everything; the product lines want to pick and choose.

module "workshop" {
  source = "./modules/workshop"

  batch_prefix = "ww-"
  pigment_pct  = 7
  shade        = "sunset orange"
}

output "label_text" {
  value = module.workshop.label_text
}
