run "creates_file" {
  command = apply

  assert {
    condition     = output.file_path != ""
    error_message = "file_path output should not be empty"
  }
}
