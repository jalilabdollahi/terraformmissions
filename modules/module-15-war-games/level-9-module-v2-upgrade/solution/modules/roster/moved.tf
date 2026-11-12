# v2.0 renames - tell Terraform these are the same objects.
moved {
  from = random_pet.member
  to   = random_pet.callsign
}

moved {
  from = local_file.card
  to   = local_file.duty_card
}
