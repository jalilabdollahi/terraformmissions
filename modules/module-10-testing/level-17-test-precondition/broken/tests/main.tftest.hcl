run "test_empty_filename" {
  command = "plan"

  variables {
    filename = ""  # empty — triggers validation error on var.filename
  }

  # Wrong: the check is on var.filename, not on the resource
  expect_failures = [
    local_file.config,
  ]
}
