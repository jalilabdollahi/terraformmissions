# Wrong: "tests" is not a valid block type — it should be "run"
tests "verify_greeting" {
  assert {
    condition     = output.greeting == "hello"
    error_message = "Greeting output should be 'hello'."
  }
}
