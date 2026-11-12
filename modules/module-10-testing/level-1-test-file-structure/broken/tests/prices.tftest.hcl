test "single_print" {
  command = plan

  assert {
    condition     = output.price_cents == 140
    error_message = "one print should cost the base price of 140 cents"
  }
}

test "three_prints" {
  command = plan

  variables {
    prints = 3
  }

  assert {
    condition     = output.price_cents == 250
    error_message = "three prints should cost 140 + 2 * 55 = 250 cents"
  }
}

test "discount_half" {
  command = plan

  variables {
    prints = 3
    discount = true
  }

  assert {
    condition     = output.price_cents == 125
    error_message = "a loyalty card on three prints pays half of 250 = 125 cents"
  }
}
