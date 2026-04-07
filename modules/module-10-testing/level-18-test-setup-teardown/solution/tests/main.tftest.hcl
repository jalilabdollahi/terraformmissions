run "setup" {
  command = "apply"
}

run "check" {
  command = "apply"

  assert {
    condition     = output.manifest_path != ""
    error_message = "Manifest path should be set after setup run."
  }
}
