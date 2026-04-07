run "verify_file" {
  # Using plan but asserting a value only known after apply
  command = "plan"

  assert {
    condition     = output.file_id != ""
    error_message = "File ID should not be empty after creation."
  }
}
