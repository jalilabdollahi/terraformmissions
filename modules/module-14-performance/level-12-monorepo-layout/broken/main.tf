# Cullen Junction signalling: everything in one root module and one state.
# The three subsystems share the module library but should not share a state.

module "interlocking" {
  source  = "./modules/signal_sheet"
  box     = "interlocking"
  out_dir = "${path.root}/out"
  lines   = [
    "Signal 12 holds at danger while points 7 are reversed",
    "Release only after track circuit TC-4 clears",
  ]
}

module "timetable" {
  source  = "./modules/signal_sheet"
  box     = "timetable"
  out_dir = "${path.root}/out"
  lines   = [
    "06:12 Cullen Junction to Bramley, platform 2",
    "06:40 Bramley to Cullen Junction, platform 1",
  ]
}

module "platform_display" {
  source  = "./modules/signal_sheet"
  box     = "platform-display"
  out_dir = "${path.root}/out"
  lines   = [
    "Platform 2: next train 06:12 to Bramley",
    "Mind the gap at car 3",
  ]
}
