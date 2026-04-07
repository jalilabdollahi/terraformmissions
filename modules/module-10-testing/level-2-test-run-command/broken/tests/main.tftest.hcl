run "check_config" {
  # "apply_all" is not a valid command — only "apply" or "plan" are accepted
  command = "apply_all"

  assert {
    condition     = output.status == "configured"
    error_message = "Status should be 'configured'."
  }
}
