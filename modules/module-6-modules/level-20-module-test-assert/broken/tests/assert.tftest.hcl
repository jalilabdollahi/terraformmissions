run "check_output" {
  command = apply

  assert {
    # Wrong expected value: the module outputs "correct", not "wrong"
    condition     = output.result == "wrong"
    error_message = "result should equal 'correct'"
  }
}
