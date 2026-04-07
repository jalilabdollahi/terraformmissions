run "verify_count" {
  command = "apply"

  variables {
    item_count = 3
  }

  assert {
    condition     = output.item_count == 3
    error_message = "Item count should be 3."
  }
}
