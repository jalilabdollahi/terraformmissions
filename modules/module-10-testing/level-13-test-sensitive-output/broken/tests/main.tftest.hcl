run "check_password" {
  command = "apply"

  assert {
    # Cannot directly compare sensitive values in conditions
    condition     = output.password == "secret123"
    error_message = "Password output should equal the input."
  }
}
