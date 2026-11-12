# Skerrow Point Lifeboat Station — crew roster, using the station-roster module.
# The vendored module was upgraded to v2.0 (see modules/roster/CHANGELOG.txt).
# Call-signs are painted on helmets and logged by the coastguard: they must not change.

locals {
  crew = {
    alma   = "coxswain"
    brecon = "mechanic"
    cullen = "helm"
    dara   = "navigator"
    emlyn  = "deckhand"
  }
}

module "roster" {
  source = "./modules/roster"

  members     = local.crew
  shift_hours = 12
}

output "crew_callsigns" {
  value = module.roster.callsigns
}
