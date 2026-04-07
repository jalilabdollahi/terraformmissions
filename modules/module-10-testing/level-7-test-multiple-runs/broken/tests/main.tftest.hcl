run "first" {
  command = "apply"
}

run "second" {
  command = "apply"

  assert {
    # Wrong: run.first.output.file_path is not valid — use output.file_path directly
    condition     = run.first.output.file_path != ""
    error_message = "File path should not be empty."
  }
}
