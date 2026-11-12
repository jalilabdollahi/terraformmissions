# Brightside Speedcubing Open — results board.
# Solve times (seconds) are typed in by judges at the tables, so they arrive as messy text.

variable "raw_times" {
  type = map(string)
  default = {
    Mika = "12.5"
    Dara = "13,1"
    Luka = "DNF"
    Noor = " 11.9"
    Arlo = "DSQ"
  }
}

locals {
  cleaned = { for cuber, t in var.raw_times : cuber => t }
  finishers = {
    for cuber, t in local.cleaned : cuber => tonumber(t)
  }
  fastest = min(values(local.finishers)...)
}

resource "local_file" "results" {
  filename = "${path.module}/board/results.txt"
  content = "${join("\n", concat(
    [for cuber, seconds in local.finishers : "${cuber}: ${seconds} sec"],
    [for cuber in sort(keys(var.raw_times)) : "${cuber}: no time" if !contains(keys(local.finishers), cuber)],
  ))}\n"
}

output "finishers" {
  value = local.finishers
}

output "no_time" {
  value = sort([for cuber in keys(var.raw_times) : cuber if !contains(keys(local.finishers), cuber)])
}

output "winner" {
  value = one([for cuber, seconds in local.finishers : cuber if seconds == local.fastest])
}

output "fastest_seconds" {
  value = local.fastest
}
