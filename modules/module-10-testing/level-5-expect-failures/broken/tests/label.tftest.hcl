run "default_label" {
  command = plan

  assert {
    condition     = output.label == "250 mg every 8 h" && output.daily_total_mg == 750
    error_message = "the default label is 250 mg every 8 h, 750 mg per day"
  }
}

run "dose_too_high" {
  command = plan

  variables {
    dose_mg = 900
  }

  expect_failures = [
    variable.dose_mg,
  ]
}

run "interval_too_short" {
  command = plan

  variables {
    interval_hours = 1
  }

  expect_failures = [
    var.dose_mg,
  ]
}
