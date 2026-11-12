run "formula_file_written" {
  command = plan

  assert {
    condition     = fileexists(local_file.formula.filename)
    error_message = "the formula card should exist on disk"
  }

  assert {
    condition     = strcontains(file(local_file.formula.filename), "pigment: 800 g")
    error_message = "the card should list pigment at 800 g for the default 2 kg batch"
  }
}

run "total_for_default_batch" {
  command = plan

  assert {
    condition     = output.total_grams == 2000
    error_message = "a 2 kg batch is 2000 g in total"
  }
}

run "bigger_batch" {
  command = plan

  variables {
    batch_kg = 5
  }

  assert {
    condition     = output.total_grams == 5000
    error_message = "a 5 kg batch is 5000 g in total"
  }
}
