run "ratio_label" {
  command = plan

  assert {
    condition     = output.ratio_label == "3:2"
    error_message = "the default mix label is 3:2"
  }
}

run "batch_code_shape" {
  command = apply

  assert {
    condition     = can(regex("^PB-[0-9A-F]{8}$", output.batch_code))
    error_message = "batch codes look like PB- followed by eight upper-case hex digits"
  }
}

run "tint_in_range" {
  command = apply

  assert {
    condition     = output.tint_number >= 10 && output.tint_number <= 99
    error_message = "tint numbers are two digits, 10 to 99"
  }
}
