run "verify_count" {
  command = "apply"

  variables {
    # Wrong: "three" is a string but var.item_count expects a number
    item_count = "three"
  }

  assert {
    condition     = output.item_count == 3
    error_message = "Item count should be 3."
  }
}
