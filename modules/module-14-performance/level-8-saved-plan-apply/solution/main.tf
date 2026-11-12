# Ludlow Land Registry Office: title register, one file per transfer.

variable "transfers" {
  type = map(string)
  default = {
    "t-3011" = "Plot 14 Elm Lane: Hartnell to Quayle, 2026-03-04, Desk 2"
    "t-3012" = "Marchbank Estate: boundary correction, 2026-03-04, Desk 1"
    "t-3013" = "Orrin Mills: lease to County Roads, 2026-03-05, Desk 2"
    "t-3014" = "Pell Farm: split title, 2026-03-06, Desk 3"
    "t-3015" = "Tidewater Co-op: mortgage release, 2026-03-06, Desk 1"
  }
}

resource "local_file" "register" {
  for_each = var.transfers
  filename = "${path.module}/register/${each.key}.txt"
  content  = "Title ${each.key}: ${each.value}\n"
}

output "registered" {
  value = sort(keys(local_file.register))
}
