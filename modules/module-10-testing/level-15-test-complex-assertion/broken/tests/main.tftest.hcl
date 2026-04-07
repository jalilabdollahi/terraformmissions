run "check_outputs" {
  command = "apply"

  assert {
    # output.b is "y" but we're checking for "wrong" — second clause always fails
    condition     = output.a == "x" && output.b == "wrong"
    error_message = "Both outputs should match expected values."
  }
}
