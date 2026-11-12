# Tallow and Thyme candle works.
# One module does everything; the product lines want to pick and choose.

module "workshop" {
  source = "./modules/workshop"

  batch_prefix = "tt-"
  wick_cm      = 7
  scent        = "fig and cedar"
}

output "label_text" {
  value = module.workshop.label_text
}
