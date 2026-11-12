# Every address the count -> for_each refactor changed (old order from legacy manifest).

moved {
  from = random_id.cart_serial[0]
  to   = random_id.cart["CT-1"]
}

moved {
  from = random_id.cart_serial[1]
  to   = random_id.cart["CT-2"]
}

moved {
  from = random_id.cart_serial[2]
  to   = random_id.cart["CT-3"]
}

moved {
  from = random_id.cart_serial[3]
  to   = random_id.cart["CT-4"]
}

moved {
  from = random_id.cart_serial[4]
  to   = random_id.cart["CT-5"]
}

moved {
  from = random_id.cart_serial[5]
  to   = random_id.cart["CT-6"]
}

moved {
  from = random_integer.lot_slot[0]
  to   = random_integer.lot["C3"]
}

moved {
  from = random_integer.lot_slot[1]
  to   = random_integer.lot["A1"]
}

moved {
  from = random_integer.lot_slot[2]
  to   = random_integer.lot["B2"]
}

moved {
  from = random_integer.lot_slot[3]
  to   = random_integer.lot["G7"]
}

moved {
  from = random_integer.lot_slot[4]
  to   = random_integer.lot["D4"]
}

moved {
  from = random_integer.lot_slot[5]
  to   = random_integer.lot["F6"]
}

moved {
  from = random_integer.lot_slot[6]
  to   = random_integer.lot["E5"]
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
  to   = random_uuid.house_licence
}

moved {
  from = time_static.go_live
  to   = time_static.opening
}
