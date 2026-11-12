run "arrow_card" {
  command = plan

  assert {
    condition     = local_file.stand_card[0].content == "Stand 3: arrow (roadster)\n"
    error_message = "the roadster is on stand 3"
  }
}

run "regent_card" {
  command = plan

  assert {
    condition     = startswith(local_file.stand_card["Regent"].content, "Stand 7:")
    error_message = "the saloon is on stand 7"
  }

  assert {
    condition     = endswith(local_file.stand_card["Regent"].filename, "cards/regent.txt")
    error_message = "cards are named after the entry key"
  }
}

run "all_cards_issued" {
  command = plan

  assert {
    condition     = length(local_file.stand_card) == 3
    error_message = "three entries, three cards"
  }

  assert {
    condition     = alltrue([for key, card in local_file.stand_card : startswith(card.content, "Stand ")])
    error_message = "every card starts with its stand number"
  }
}
