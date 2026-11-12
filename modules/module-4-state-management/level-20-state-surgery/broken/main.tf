# Three Rivers Grain Co-op: harvest dispatch.
# Three things drifted between code and state:
#   - the operator resource was renamed in a refactor (harvester -> combine_operator)
#   - the silo number is in the code but missing from the state
#   - the retired gauge log was deleted from the code on purpose; its file stays

resource "random_pet" "combine_operator" {
  length    = 2
  separator = "-"
  prefix    = "op"
}

resource "random_integer" "silo_number" {
  min = 100
  max = 999
}

resource "local_file" "dispatch_sheet" {
  filename = "${path.module}/dispatch/today.txt"
  content  = "Operator ${random_pet.combine_operator.id} delivers to silo ${random_integer.silo_number.result}\n"
}
