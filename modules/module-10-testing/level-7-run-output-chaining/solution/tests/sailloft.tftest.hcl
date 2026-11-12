run "measure_main" {
  command = plan

  assert {
    condition     = output.sail_area == 12
    error_message = "an 8 m luff on a 3 m foot is 12 m2"
  }
}

run "order_cloth" {
  command = plan

  variables {
    order_area_m2 = run.measure_main.sail_area
  }

  assert {
    condition     = output.cloth_ordered_m2 == 14
    error_message = "12 m2 plus a 10 percent allowance rounds up to 14 m2 of cloth"
  }
}

run "spare_jib" {
  command = plan

  variables {
    luff_m = 4
    foot_m = 1.5
  }

  assert {
    condition     = output.cloth_ordered_m2 < run.order_cloth.cloth_ordered_m2
    error_message = "the jib must need less cloth than the mainsail order"
  }
}
