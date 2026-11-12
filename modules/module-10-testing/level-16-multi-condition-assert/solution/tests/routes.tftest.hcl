run "classic_route" {
  command = plan

  assert {
    condition     = output.route.grade == "6a"
    error_message = "the classic route is graded 6a"
  }

  assert {
    condition     = output.route.colour == "green"
    error_message = "grade 6a holds are green"
  }

  assert {
    condition     = output.route.bolts == 9
    error_message = "a 17 m route needs 9 bolts"
  }

  assert {
    condition     = output.route.top_rope_ok
    error_message = "a 17 m route is low enough for top rope"
  }
}

run "tall_route" {
  command = plan

  variables {
    grade    = "7a"
    height_m = 24
  }

  assert {
    condition     = output.route.colour == "red"
    error_message = "grade 7a holds are red"
  }

  assert {
    condition     = output.route.bolts == 12
    error_message = "a 24 m route needs 12 bolts"
  }

  assert {
    condition     = !output.route.top_rope_ok
    error_message = "a 24 m route is too tall for top rope"
  }
}
