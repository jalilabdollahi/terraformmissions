run "nomad_card" {
  command = plan

  assert {
    condition     = local_file.pitch_card["nomad"].content == "Pitch 3: nomad (campervan)\n"
    error_message = "the campervan is on pitch 3"
  }
}

run "voyager_card" {
  command = plan

  assert {
    condition     = startswith(local_file.pitch_card["voyager"].content, "Pitch 7:")
    error_message = "the caravan is on pitch 7"
  }

  assert {
    condition     = endswith(local_file.pitch_card["voyager"].filename, "cards/voyager.txt")
    error_message = "cards are named after the vehicle key"
  }
}

run "all_cards_issued" {
  command = plan

  assert {
    condition     = length(local_file.pitch_card) == 3
    error_message = "three vehicles, three cards"
  }

  assert {
    condition     = alltrue([for key, card in local_file.pitch_card : startswith(card.content, "Pitch ")])
    error_message = "every card starts with its pitch number"
  }
}
