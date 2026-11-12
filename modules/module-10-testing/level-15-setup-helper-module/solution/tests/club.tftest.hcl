run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }
}

run "short_show" {
  variables {
    lineup_path = run.setup.lineup_path
  }

  assert {
    condition     = output.act_count == 3 && output.total_minutes == 105
    error_message = "the default show is three acts, 105 minutes"
  }

  assert {
    condition     = !output.needs_intermission
    error_message = "105 minutes needs no intermission"
  }
}

run "setup_long" {
  command = apply

  module {
    source = "./tests/setup"
  }

  variables {
    acts = [
      { title = "Host intro", minutes = 12 },
      { title = "First half", minutes = 95 },
      { title = "Second half", minutes = 93 },
    ]
  }
}

run "double_header" {
  variables {
    lineup_path = run.setup_long.lineup_path
  }

  assert {
    condition     = output.total_minutes == 200 && output.needs_intermission
    error_message = "200 minutes must trigger an intermission"
  }
}
