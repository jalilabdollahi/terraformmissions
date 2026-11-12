# Tannenbaum cuckoo clock repair bench: one ticket record per clock on the bench.
# The workshop log (repairs/bench.log) must say when a ticket is opened and when it is
# closed. "Closed" is written by a destroy-time provisioner, which runs when the ticket
# record is removed or replaced.

variable "ticket" {
  type    = string
  default = "CC-2041"
}

variable "clock" {
  type    = string
  default = "Black Forest wall cuckoo"
}

resource "terraform_data" "repair_ticket" {
  input = {
    ticket = var.ticket
    clock  = var.clock
  }

  provisioner "local-exec" {
    command = "mkdir -p repairs && echo 'opened ${self.input.ticket} (${self.input.clock})' >> repairs/bench.log"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "mkdir -p repairs && echo 'closed ${self.input.ticket}' >> repairs/bench.log"
  }
}
