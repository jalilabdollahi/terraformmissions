run "calm_morning" {
  command = plan

  override_data {
    target = data.local_file.windmeter
    values = {
      content = "6"
    }
  }

  assert {
    condition     = output.play_status == "open"
    error_message = "6 kph is a good day for disc golf"
  }
}

run "gale_warning" {
  command = plan

  override_data {
    target = data.local_file.windmeter
    values = {
      content = "34"
    }
  }

  assert {
    condition     = output.play_status == "closed"
    error_message = "34 kph closes the whole course"
  }
}

run "gusty_edge" {
  command = plan

  override_data {
    target = data.local_file.windmeter
    values = {
      content = "18"
    }
  }

  assert {
    condition     = output.play_status == "closed"
    error_message = "exactly 18 kph is already too much: the limit is strictly below 18"
  }
}
