provider "local" {}

provider "local" {
  alias = "offsite"
}

module "ledger" {
  source = "./modules/ledger"

  treatment = "Weft re-weaving, Flemish hunt tapestry 1594"
}

output "ledger_files" {
  value = module.ledger.files
}
