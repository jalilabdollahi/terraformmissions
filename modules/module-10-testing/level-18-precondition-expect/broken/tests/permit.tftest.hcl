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
    var.shell_kg,
  ]
}

run "too_tall" {
  command = plan

  expect_failures = [
    terraform_data.display_permit,
  ]
}
