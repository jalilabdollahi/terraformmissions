run "setup" {
  command = "apply"
  # Creates all resources including the expected manifest
}

run "check" {
  command = "apply"

  assert {
    # manifest_path output does not exist — local_file.manifest resource is missing
    condition     = output.manifest_path != ""
    error_message = "Manifest path should be set after setup run."
  }
}
