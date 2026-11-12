# Milkhouse refactor: every changed address, plus the retired trial batch.

moved {
  from = random_id.vat_serial
  to   = module.milkhouse.random_id.vat_serial
}

moved {
  from = random_integer.room_shelves[0]
  to   = module.caves.module.rooms.random_integer.shelves["r2"]
}

moved {
  from = random_integer.room_shelves[1]
  to   = module.caves.module.rooms.random_integer.shelves["r1"]
}

moved {
  from = random_integer.room_shelves[2]
  to   = module.caves.module.rooms.random_integer.shelves["r3"]
}

moved {
  from = random_uuid.licence
  to   = module.compliance.random_uuid.licence
}

moved {
  from = time_static.first_churn
  to   = module.compliance.time_static.first_churn
}

moved {
  from = null_resource.cip_cycle
  to   = module.caves.terraform_data.cip_cycle
}

moved {
  from = module.rennet
  to   = module.cultures
}

moved {
  from = module.cultures.random_integer.strain
  to   = module.cultures.random_integer.strain_grams
}

removed {
  from = random_integer.trial_batch

  lifecycle {
    destroy = false
  }
}
