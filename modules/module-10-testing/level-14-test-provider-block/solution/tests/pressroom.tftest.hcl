provider "local" {
  alias = "press"
}

provider "local" {
  alias = "vault"
}

run "sleeve_goes_to_press" {
  command = plan

  assert {
    condition     = strcontains(local_file.sleeve_note.filename, "/press/")
    error_message = "the sleeve note belongs in the press directory"
  }
}

run "master_is_read_only" {
  command = plan

  providers = {
    local.press = local.press
    local.vault = local.vault
  }

  assert {
    condition     = local_file.master_log.file_permission == "0400"
    error_message = "master logs must be read-only"
  }
}

run "catalog_number_flows" {
  command = plan

  variables {
    catalog_no = "ZX-77"
  }

  assert {
    condition     = endswith(local_file.master_log.filename, "ZX-77-master.log") && endswith(local_file.sleeve_note.filename, "ZX-77.txt")
    error_message = "the catalogue number must appear in both file names"
  }
}
