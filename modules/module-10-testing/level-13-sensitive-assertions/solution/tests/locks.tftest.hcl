run "code_policy" {
  assert {
    condition     = length(output.lock_code) == 8
    error_message = "lock codes are 8 digits, got ${nonsensitive(length(output.lock_code))}"
  }

  assert {
    condition     = can(regex("^[0-9]+$", output.lock_code))
    error_message = "lock codes are numeric only"
  }
}

run "public_label" {
  command = plan

  assert {
    condition     = output.unit_label == "Unit A-14"
    error_message = "the label shown to customers is Unit A-14"
  }
}
