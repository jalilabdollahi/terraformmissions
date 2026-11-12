# Every address the count -> for_each refactor changed (old order from legacy manifest).

moved {
  from = random_id.loader_serial[0]
  to   = random_id.loader["LD-1"]
}

moved {
  from = random_id.loader_serial[1]
  to   = random_id.loader["LD-2"]
}

moved {
  from = random_id.loader_serial[2]
  to   = random_id.loader["LD-3"]
}

moved {
  from = random_id.loader_serial[3]
  to   = random_id.loader["LD-4"]
}

moved {
  from = random_id.loader_serial[4]
  to   = random_id.loader["LD-5"]
}

moved {
  from = random_id.loader_serial[5]
  to   = random_id.loader["LD-6"]
}

moved {
  from = random_integer.stand_slot[0]
  to   = random_integer.stand["C3"]
}

moved {
  from = random_integer.stand_slot[1]
  to   = random_integer.stand["A1"]
}

moved {
  from = random_integer.stand_slot[2]
  to   = random_integer.stand["B2"]
}

moved {
  from = random_integer.stand_slot[3]
  to   = random_integer.stand["G7"]
}

moved {
  from = random_integer.stand_slot[4]
  to   = random_integer.stand["D4"]
}

moved {
  from = random_integer.stand_slot[5]
  to   = random_integer.stand["F6"]
}

moved {
  from = random_integer.stand_slot[6]
  to   = random_integer.stand["E5"]
}

moved {
  from = terraform_data.dock_door[0]
  to   = terraform_data.dock["out-1"]
}

moved {
  from = terraform_data.dock_door[1]
  to   = terraform_data.dock["in-1"]
}

moved {
  from = terraform_data.dock_door[2]
  to   = terraform_data.dock["in-2"]
}

moved {
  from = terraform_data.dock_door[3]
  to   = terraform_data.dock["out-2"]
}

moved {
  from = terraform_data.dock_door[4]
  to   = terraform_data.dock["in-3"]
}

moved {
  from = random_uuid.ops_licence
  to   = random_uuid.hub_licence
}

moved {
  from = time_static.go_live
  to   = time_static.opening
}
