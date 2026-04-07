run "test_greeting" {
  command = "apply"

  assert {
    condition     = output.greeting == "Hello, TerraformMissions!"
    error_message = "Greeting should include the provided name."
  }
}
