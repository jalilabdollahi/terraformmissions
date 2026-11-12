run "calm_morning" {
  command = plan

  override_data {
    target = data.local_file.anemometer
    values = {
      content = "6"
    }
  }

  assert {
    condition     = output.flight_status == "fly"
    error_message = "6 knots is a good day for kites"
  }
}

run "gale_warning" {
  command = plan

  override_data {
    target = data.local_file.anemometer
    values = {
      content = "34"
    }
  }

  assert {
    condition     = output.flight_status == "ground"
    error_message = "34 knots grounds every kite"
  }
}

run "gusty_edge" {
  command = plan

  override_data {
    target = data.local_file.anemometer
    values = {
      content = "18"
    }
  }

  assert {
    condition     = output.flight_status == "ground"
    error_message = "exactly 18 knots is already too much: the limit is strictly below 18"
  }
}
