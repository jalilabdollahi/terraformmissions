run "roomy_coop" {
  command = plan

  assert {
    condition     = output.hens_total == 14 && !output.overstocked
    error_message = "14 hens in 120 sq ft is comfortable"
  }
}

run "crowded_coop" {
  command = plan

  variables {
    coop_sqft = 40
  }

  assert {
    condition     = output.overstocked
    error_message = "14 hens in 40 sq ft is overstocked"
  }
}

run "bantam_flock" {
  command = plan

  variables {
    stock = {
      bantam = 30
    }
  }

  assert {
    condition     = output.hens_total == 30 && output.overstocked
    error_message = "30 bantams in the default 120 sq ft is overstocked"
  }
}
