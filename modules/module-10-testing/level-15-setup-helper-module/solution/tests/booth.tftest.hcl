run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }
}

run "short_programme" {
  variables {
    manifest_path = run.setup.manifest_path
  }

  assert {
    condition     = output.reel_count == 3 && output.total_minutes == 105
    error_message = "the default programme is three reels, 105 minutes"
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
    reels = [
      { title = "Overture", minutes = 12 },
      { title = "Part one", minutes = 95 },
      { title = "Part two", minutes = 93 },
    ]
  }
}

run "double_bill" {
  variables {
    manifest_path = run.setup_long.manifest_path
  }

  assert {
    condition     = output.total_minutes == 200 && output.needs_intermission
    error_message = "200 minutes must trigger an intermission"
  }
}
