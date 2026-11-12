# Apiary inspection log for the Thistledown hives.
variable "hives" {
  type = map(number)
  default = {
    "clover-row"  = 48000
    "heather-row" = 36500
  }
}

resource "local_file" "inspection" {
  filename = "${path.module}/apiary/inspection.txt"
  content = join("\n", [
    for name, bees in var.hives : "${name}: ~${bees} bees"
  ])
}

output "total_bees" {
  value = sum(values(var.hives))
}
