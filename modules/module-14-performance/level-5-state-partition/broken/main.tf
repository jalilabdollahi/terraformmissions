# Marrow Quay terminal: everything in one state.

# --- yard identity (rarely changes, painted on trucks) ---------------------------
resource "random_pet" "yard_name" {
  length = 2
  prefix = "quay"
}

resource "random_integer" "gate_count" {
  min = 6
  max = 24
}

# --- shift planning (changes daily) ----------------------------------------------
resource "local_file" "crane_roster" {
  filename = "${path.module}/cranes/roster.txt"
  content  = "${random_pet.yard_name.id} runs ${random_integer.gate_count.result} gates; cranes 1-6 on days\n"
}

output "yard_name" {
  value = random_pet.yard_name.id
}
