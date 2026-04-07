run "test_port_validation" {
  command = "plan"

  variables {
    port = 80  # below minimum — triggers validation error
  }

  expect_failures = [
    var.port,
  ]
}
