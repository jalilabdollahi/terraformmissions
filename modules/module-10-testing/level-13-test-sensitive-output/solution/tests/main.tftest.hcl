run "check_password" {
  command = "apply"

  assert {
    condition     = output.password != ""
    error_message = "Password output should not be empty."
  }
}
