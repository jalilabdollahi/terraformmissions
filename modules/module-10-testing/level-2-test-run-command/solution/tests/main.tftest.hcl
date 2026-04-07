run "check_config" {
  command = "apply"

  assert {
    condition     = output.status == "configured"
    error_message = "Status should be 'configured'."
  }
}
