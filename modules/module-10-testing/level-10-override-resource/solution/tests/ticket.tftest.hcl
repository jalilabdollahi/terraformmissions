override_resource {
  target = module.mainspring.random_integer.tension
  values = {
    result = 8
  }
}

run "ticket_default" {
  override_resource {
    target = random_integer.bench_slot
    values = {
      result = 3
    }
  }

  assert {
    condition     = output.ticket == "bench-3/turns-8"
    error_message = "slot 3 and 8 winding turns give bench-3/turns-8"
  }
}

run "ticket_reprinted" {
  assert {
    condition     = output.ticket == run.ticket_default.ticket
    error_message = "reprinting must give the same ticket, the pinned values persist in state"
  }
}
