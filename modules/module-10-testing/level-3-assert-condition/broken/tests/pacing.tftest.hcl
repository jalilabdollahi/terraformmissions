run "default_runner" {
  command = plan

  assert {
    condition     = output.finish_minutes >= 360
    error_message = "a 5:30/km runner must finish inside the 6 h cutoff"
  }

  assert {
    condition     = alltrue([for i in range(1, length(output.checkpoint_minutes)) : output.checkpoint_minutes[i] < output.checkpoint_minutes[i - 1]])
    error_message = "checkpoint times must increase along the course"
  }

  assert {
    condition     = output.finish_minutes == 232
    error_message = "42.195 km at 330 s/km is 232 whole minutes"
  }
}

run "slow_runner" {
  command = plan

  variables {
    pace_sec_per_km = 540
  }

  assert {
    condition     = output.within_cutoff
    error_message = "a 9:00/km runner finishes after 379 minutes and must be flagged as missing the cutoff"
  }
}
