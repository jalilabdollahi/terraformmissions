run "check_result" {
  command = "apply"

  assert {
    # The expected value is wrong — output.result is actually "correct_value"
    condition     = output.result == "wrong_value"
    error_message = "Result should equal the expected application value."
  }
}
