run "block_fabric" {
  command = plan

  module {
    source = "./modules/block"
  }

  assert {
    condition     = output.fabric_cm2 == 3468
    error_message = "twelve 15 cm blocks with seams need 3468 cm2"
  }
}

run "border_fabric" {
  command = plan

  module {
    source = "./modules/border"
  }

  assert {
    condition     = output.border_cm2 == 7400
    error_message = "a 10 cm border around 150 x 200 needs 7400 cm2"
  }
}

run "kit_total" {
  command = plan

  assert {
    condition     = output.total_cm2 == 10868
    error_message = "the full kit is blocks plus border: 10868 cm2"
  }
}
