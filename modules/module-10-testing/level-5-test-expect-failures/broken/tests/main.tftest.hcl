run "test_port_validation" {
  command = "plan"

  variables {
    port = 80  # below minimum — should trigger validation error
  }

  # Wrong: the address is a quoted string, not an unquoted reference
  expect_failures = [
    "var.port",
  ]
}
