run "check_outputs" {
  command = "apply"

  assert {
    condition     = output.a == "x" && output.b == "y"
    error_message = "Both outputs should match expected values: a='x', b='y'."
  }
}
