run "tacotl_card" {
  command = plan

  assert {
    condition     = local_file.board_card[0].content == "Pitch 3: tacotl (mexican)\n"
    error_message = "the taco truck is on pitch 3"
  }
}

run "pierogi_card" {
  command = plan

  assert {
    condition     = startswith(local_file.board_card["Pierogi"].content, "Pitch 7:")
    error_message = "the pierogi truck is on pitch 7"
  }

  assert {
    condition     = endswith(local_file.board_card["Pierogi"].filename, "cards/pierogi.txt")
    error_message = "cards are named after the truck key"
  }
}

run "all_cards_issued" {
  command = plan

  assert {
    condition     = length(local_file.board_card) == 3
    error_message = "three trucks, three cards"
  }

  assert {
    condition     = alltrue([for key, card in local_file.board_card : startswith(card.content, "Pitch ")])
    error_message = "every card starts with its pitch number"
  }
}
