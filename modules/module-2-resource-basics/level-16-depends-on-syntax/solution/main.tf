# Clue list for the weekly crossword from the Marlow Street compiling desk.
# The clue counter reads clues.txt, so it must only run once that file is
# in place. Terraform can't see that dependency by itself (the counter is a
# shell command that reads the file by path), so the author declared it.

resource "local_file" "clues" {
  filename = "${path.module}/puzzle/clues.txt"
  content  = "Small boat (5)\nFlightless bird (3)\nMusical note (4)\nEgyptian river (4)\nGarden tool (4)\n"
}

resource "terraform_data" "clue_counter" {
  depends_on = [local_file.clues]

  provisioner "local-exec" {
    command = "wc -l < puzzle/clues.txt | tr -d ' ' > puzzle/clue-count.txt"
  }
}

resource "local_file" "title" {
  filename   = "${path.module}/puzzle/title.txt"
  content    = "THE MARLOW STREET CROSSWORD\n"
  depends_on = [local_file.clues]
}

output "counter_id" {
  value = terraform_data.clue_counter.id
}
