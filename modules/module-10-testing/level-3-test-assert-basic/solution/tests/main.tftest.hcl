run "check_result" {
  command = "apply"

  assert {
    condition     = output.result == "correct_value"
    error_message = "Result should equal the expected application value."
  }
}
