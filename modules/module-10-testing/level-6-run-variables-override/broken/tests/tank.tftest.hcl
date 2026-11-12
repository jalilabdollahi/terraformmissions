run "roomy_tank" {
  command = plan

  assert {
    condition     = output.fish_total == 14 && !output.overstocked
    error_message = "14 fish in 120 litres is comfortable"
  }
}

run "crowded_tank" {
  command = plan

  variables {
    tank_liters = "40 litres"
  }

  assert {
    condition     = output.overstocked
    error_message = "14 fish in 40 litres is overstocked"
  }
}

run "guppy_swarm" {
  command = plan

  variables {
    stock = ["guppy", "guppy"]
  }

  assert {
    condition     = output.fish_total == 30 && output.overstocked
    error_message = "30 guppies in the default 120 litres is overstocked"
  }
}
