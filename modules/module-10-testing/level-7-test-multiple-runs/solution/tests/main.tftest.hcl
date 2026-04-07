run "first" {
  command = "apply"
}

run "second" {
  command = "apply"

  assert {
    condition     = output.file_path != ""
    error_message = "File path should not be empty."
  }
}
