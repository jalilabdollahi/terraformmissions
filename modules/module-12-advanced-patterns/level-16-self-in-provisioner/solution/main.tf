# Wren & Hammer piano tuner: one ticket record per piano on the round.
# The tuner's diary (visits/diary.log) must say when a ticket is opened and when it is
# closed. "Closed" is written by a destroy-time provisioner, which runs when the ticket
# record is removed or replaced.

variable "ticket" {
  type    = string
  default = "PT-2041"
}

variable "piano" {
  type    = string
  default = "Steinbeck upright piano"
}

resource "terraform_data" "tuning_ticket" {
  input = {
    ticket = var.ticket
    piano  = var.piano
  }

  provisioner "local-exec" {
    command = "mkdir -p visits && echo 'opened ${self.input.ticket} (${self.input.piano})' >> visits/diary.log"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "mkdir -p visits && echo 'closed ${self.input.ticket}' >> visits/diary.log"
  }
}
