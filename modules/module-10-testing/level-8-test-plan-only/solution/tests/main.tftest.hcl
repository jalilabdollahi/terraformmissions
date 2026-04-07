run "verify_file" {
  command = "apply"

  assert {
    condition     = output.file_id != ""
    error_message = "File ID should not be empty after creation."
  }
}
