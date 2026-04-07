run "check_files" {
  command = "apply"

  assert {
    # "wrong_key" does not exist — actual keys are "alpha" and "beta"
    condition     = output.files["wrong_key"].content == "content-alpha"
    error_message = "Alpha file should have content-alpha."
  }
}
