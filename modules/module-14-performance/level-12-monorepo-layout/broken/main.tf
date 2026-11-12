# Mapleton Crossroads traffic lights: everything in one root module and one state.
# The three subsystems share the module library but should not share a state.

module "junction_controller" {
  source  = "./modules/plan_sheet"
  unit    = "junction-controller"
  out_dir = "${path.root}/out"
  lines   = [
    "Signal 12 holds red while the tram crossing is active",
    "Release only after loop detector LD-4 clears",
  ]
}

module "bus_priority" {
  source  = "./modules/plan_sheet"
  unit    = "bus-priority"
  out_dir = "${path.root}/out"
  lines   = [
    "06:12 Route 9 to Eastgate: green extension 8s",
    "06:40 Route 9 to Mapleton: green extension 8s",
  ]
}

module "crossing_countdown" {
  source  = "./modules/plan_sheet"
  unit    = "crossing-countdown"
  out_dir = "${path.root}/out"
  lines   = [
    "Crossing 2: walk signal in 12 seconds",
    "Mind the cyclists in the bike lane",
  ]
}
