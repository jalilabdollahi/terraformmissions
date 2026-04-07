# Invalid command: "apply_all" is not a valid terraform test command.
run "creates_file" {
  command = apply_all

  assert {
    condition     = output.file_path != ""
    error_message = "file_path output should not be empty"
  }
}
