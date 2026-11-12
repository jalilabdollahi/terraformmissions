run "within_limits" {
  command = plan

  assert {
    condition     = output.permit_code == "permit:28kg/3m"
    error_message = "a 28 kg, 3 m rack display gets an ordinary permit"
  }
}

run "too_heavy" {
  command = plan

  variables {
    shell_kg = 55
  }

  expect_failures = [
    terraform_data.display_permit,
  ]
}

run "too_tall" {
  command = plan

  variables {
    rack_height_m = 5.2
  }

  expect_failures = [
    terraform_data.display_permit,
  ]
}
