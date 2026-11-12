# Movements refactor: every changed address, plus the retired prototype run.

moved {
  from = random_id.spring_serial
  to   = module.movements.random_id.spring_serial
}

moved {
  from = random_integer.stall_loads[0]
  to   = module.stables.module.stalls.random_integer.loads["h2"]
}

moved {
  from = random_integer.stall_loads[1]
  to   = module.stables.module.stalls.random_integer.loads["h1"]
}

moved {
  from = random_integer.stall_loads[2]
  to   = module.stables.module.stalls.random_integer.loads["h3"]
}

moved {
  from = random_uuid.licence
  to   = module.compliance.random_uuid.licence
}

moved {
  from = time_static.first_spin
  to   = module.compliance.time_static.first_spin
}

moved {
  from = null_resource.oil_cycle
  to   = module.stables.terraform_data.oil_cycle
}

moved {
  from = module.paint
  to   = module.finishes
}

moved {
  from = module.finishes.random_integer.coat
  to   = module.finishes.random_integer.coat_grams
}

removed {
  from = random_integer.prototype_run

  lifecycle {
    destroy = false
  }
}
