provider "local" {
  alias = "press"
}

provider "local" {
  alias = "vault"
}

run "sheet_goes_to_press" {
  command = plan

  assert {
    condition     = strcontains(local_file.strike_sheet.filename, "/press/")
    error_message = "the strike sheet belongs in the press directory"
  }
}

run "die_is_read_only" {
  command = plan

  providers = {
    local.press = local.press
    local.vault = local.vault
  }

  assert {
    condition     = local_file.die_log.file_permission == "0400"
    error_message = "die logs must be read-only"
  }
}

run "series_number_flows" {
  command = plan

  variables {
    series_no = "CX-77"
  }

  assert {
    condition     = endswith(local_file.die_log.filename, "CX-77-die.log") && endswith(local_file.strike_sheet.filename, "CX-77.txt")
    error_message = "the series number must appear in both file names"
  }
}
