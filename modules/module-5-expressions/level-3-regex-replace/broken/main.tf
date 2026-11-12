# Cinder Lane Computer Repair — intake tags for the workbench.
# Tags must show a clean serial key, a one-line fault note and a day-first date.

variable "serial_raw" {
  type    = string
  default = "  zx-4411/b.09 "
}

variable "fault_note_raw" {
  type    = string
  default = "Tape   loader failing,\t border flickers on  boot"
}

variable "intake_date" {
  type    = string
  default = "2026-03-17"
}

locals {
  serial_key = upper(replace(trimspace(var.serial_raw), "[^A-Za-z0-9]", ""))
  fault_note = replace(" ", "/\\s+/", var.fault_note_raw)
  intake_uk  = replace(var.intake_date, "^(\\d{4})-(\\d{2})-(\\d{2})$", "$3/$2/$1")
}

resource "local_file" "bench_tag" {
  filename = "${path.module}/tags/bench-tag.txt"
  content  = "Serial: ${local.serial_key}\nFault: ${local.fault_note}\nIn: ${local.intake_uk}\n"
}

output "serial_key" {
  value = local.serial_key
}

output "fault_note" {
  value = local.fault_note
}

output "intake_uk" {
  value = local.intake_uk
}
