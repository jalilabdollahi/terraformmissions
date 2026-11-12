run "tile_area" {
  command = plan

  module {
    source = "./modules/tile"
  }

  assert {
    condition     = output.tile_cm2 == 3468
    error_message = "twelve 15 cm tiles with grout need 3468 cm2"
  }
}

run "frieze_area" {
  command = plan

  module {
    source = "./modules/frieze"
  }

  assert {
    condition     = output.frieze_cm2 == 7400
    error_message = "a 10 cm frieze around 150 x 200 needs 7400 cm2"
  }
}

run "panel_total" {
  command = plan

  assert {
    condition     = output.total_cm2 == 10868
    error_message = "the full panel is tiles plus frieze: 10868 cm2"
  }
}
