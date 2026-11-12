# Lindqvist violin workshop: varnish batch VX-2210.
# The batch record carries the litres mixed and the days it must cure. A postcondition
# guards the finished record: never more than 5 litres in one batch, never less than
# 5 days of cure. The rule is written, but the configuration refuses to load.

variable "litres" {
  type    = number
  default = 4
}

variable "cure_days" {
  type    = number
  default = 6
}

resource "terraform_data" "varnish_batch" {
  input = {
    batch     = "VX-2210"
    litres    = var.litres
    cure_days = var.cure_days
  }

  lifecycle {
    postcondition {
      condition     = self.output.litres <= 5
      error_message = "A varnish batch may not exceed 5 litres."
    }

    postcondition {
      condition     = self.output.cure_days >= 5
      error_message = "Varnish needs at least 5 days to cure."
    }
  }
}

resource "local_file" "batch_label" {
  filename = "${path.module}/labels/vx-2210.txt"
  content  = "${terraform_data.varnish_batch.output.batch}: ${terraform_data.varnish_batch.output.litres} L, cure ${terraform_data.varnish_batch.output.cure_days} days\n"
}
