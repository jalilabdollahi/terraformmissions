run "classic_route" {
  command = plan

  assert {
    condition     = output.route.grade == "6a" && output.route.colour == "green" && output.route.bolts == 9 && output.route.top_rope_ok
    error_message = "route card is wrong"
  }
}

run "tall_route" {
  command = plan

  variables {
    grade    = "7a"
    height_m = 24
  }

  assert {
    condition     = output.route.colour == "red" && output.route.bolts == 12 && !output.route.top_rope_ok
    error_message = "tall route card is wrong"
  }
}
