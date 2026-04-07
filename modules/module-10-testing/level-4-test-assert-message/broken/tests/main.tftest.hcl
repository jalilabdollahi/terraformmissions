run "check_count" {
  command = "apply"

  assert {
    condition     = output.count > 0
    # Empty error_message is not allowed
    error_message = ""
  }
}
