run "check_output" {
  command = apply

  assert {
    condition     = output.result == "correct"
    error_message = "result should equal 'correct'"
  }
}
