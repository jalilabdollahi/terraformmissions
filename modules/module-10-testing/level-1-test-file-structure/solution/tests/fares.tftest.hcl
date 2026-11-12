run "single_axle" {
  command = plan

  assert {
    condition     = output.fare_cents == 140
    error_message = "one axle should cost the base fare of 140 cents"
  }
}

run "three_axles" {
  command = plan

  variables {
    axles = 3
  }

  assert {
    condition     = output.fare_cents == 250
    error_message = "three axles should cost 140 + 2 * 55 = 250 cents"
  }
}

run "discount_half" {
  command = plan

  variables {
    axles = 3
    discount = true
  }

  assert {
    condition     = output.fare_cents == 125
    error_message = "a discount pass on three axles pays half of 250 = 125 cents"
  }
}
