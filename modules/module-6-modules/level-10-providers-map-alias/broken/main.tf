provider "local" {}

provider "local" {
  alias = "offsite"
}

module "ledger" {
  source = "./modules/ledger"

  treatment = "Varnish removal, oil portrait 1887"
}

output "ledger_files" {
  value = module.ledger.files
}
