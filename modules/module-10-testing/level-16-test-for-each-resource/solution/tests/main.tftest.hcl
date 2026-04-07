run "check_files" {
  command = "apply"

  assert {
    condition     = output.files["alpha"].content == "content-alpha"
    error_message = "Alpha file should have content-alpha."
  }
}
