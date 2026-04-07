run "test_empty_filename" {
  command = "plan"

  variables {
    filename = ""  # empty — triggers validation error on var.filename
  }

  expect_failures = [
    var.filename,
  ]
}
