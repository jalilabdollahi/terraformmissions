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
  crew   = local.crew
}
output "crew_callsigns" {
  value = module.roster.member_names
}
