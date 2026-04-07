run "check_count" {
  command = "apply"

  assert {
    condition     = output.count > 0
    error_message = "Instance count must be greater than zero to ensure at least one instance is running."
  }
}
