test "single_zone" {
  command = plan

  assert {
    condition     = output.fare_cents == 140
    error_message = "one zone should cost the base fare of 140 cents"
  }
}

test "three_zones" {
  command = plan

  variables {
    zones = 3
  }

  assert {
    condition     = output.fare_cents == 250
    error_message = "three zones should cost 140 + 2 * 55 = 250 cents"
  }
}

test "child_half" {
  command = plan

  variables {
    zones = 3
    child = true
  }

  assert {
    condition     = output.fare_cents == 125
    error_message = "a child on three zones pays half of 250 = 125 cents"
  }
}
