override_resource {
  target = module.glitter.random_integer.dose
  values = {
    result = 8
  }
}

run "ticket_default" {
  override_resource {
    target = random_integer.station_slot
    values = {
      result = 3
    }
  }

  assert {
    condition     = output.ticket == "station-3/scoops-8"
    error_message = "slot 3 and 8 glitter scoops give station-3/scoops-8"
  }
}

run "ticket_reprinted" {
  assert {
    condition     = output.ticket == run.ticket_default.ticket
    error_message = "reprinting must give the same ticket, the pinned values persist in state"
  }
}
