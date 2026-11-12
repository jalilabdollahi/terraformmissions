run "within_limits" {
  command = plan

  assert {
    condition     = output.permit_code == "permit:28t/3m"
    error_message = "a 28 t, 3 m vehicle gets an ordinary permit"
  }
}

run "too_heavy" {
  command = plan

  variables {
    vehicle_tonnes = 55
  }

  expect_failures = [
    terraform_data.crossing_permit,
  ]
}

run "too_tall" {
  command = plan

  variables {
    vehicle_height_m = 5.2
  }

  expect_failures = [
    terraform_data.crossing_permit,
  ]
}
