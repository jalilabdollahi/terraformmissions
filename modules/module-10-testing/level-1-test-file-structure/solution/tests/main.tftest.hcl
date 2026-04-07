run "verify_greeting" {
  assert {
    condition     = output.greeting == "hello"
    error_message = "Greeting output should be 'hello'."
  }
}
