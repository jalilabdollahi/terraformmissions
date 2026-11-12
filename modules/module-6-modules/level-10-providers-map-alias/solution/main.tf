provider "local" {}

provider "local" {
  alias = "offsite"
}

module "ledger" {
  source = "./modules/ledger"

  providers = {
    local        = local
    local.mirror = local.offsite
  }

  treatment = "Varnish removal, oil portrait 1887"
}

output "ledger_files" {
  value = module.ledger.files
}
