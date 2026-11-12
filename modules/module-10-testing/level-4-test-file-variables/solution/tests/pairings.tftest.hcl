variables {
  club    = "Rook and Pawn"
  players = ["Ines", "Tomas", "Wen", "Abebe"]
}

run "even_roster" {
  command = plan

  assert {
    condition     = output.boards == 2 && output.byes == 0
    error_message = "four players need two boards and nobody sits out"
  }

  assert {
    condition     = output.sheet_title == "Rook and Pawn: 2 boards"
    error_message = "the title should come from the file-level club name"
  }
}

run "odd_roster_gets_bye" {
  command = plan

  variables {
    players = ["Ines", "Tomas", "Wen", "Abebe", "Priya"]
  }

  assert {
    condition     = output.boards == 3 && output.byes == 1
    error_message = "five players need three boards and one bye"
  }

  assert {
    condition     = output.sheet_title == "Rook and Pawn: 3 boards"
    error_message = "the club name must still come from the file-level block"
  }
}
