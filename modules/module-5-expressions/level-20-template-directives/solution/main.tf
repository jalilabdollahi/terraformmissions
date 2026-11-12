# Nightjar Express — sleeper-car manifest slipped under the conductor's door.

variable "destination" {
  type    = string
  default = "Inverness"
}

variable "passengers" {
  type = list(object({
    berth     = string
    name      = string
    breakfast = bool
  }))
  default = [
    { berth = "A1", name = "Mrs Dunlop", breakfast = true },
    { berth = "A2", name = "Mr Ito", breakfast = false },
    { berth = "B4", name = "Dr Okonkwo", breakfast = true },
  ]
}

locals {
  manifest = <<EOT
Nightjar Express to ${var.destination}
Berths:
%{ for p in var.passengers ~}
  ${p.berth}  ${p.name}%{ if p.breakfast } (breakfast)%{ endif }
%{ endfor ~}
%{ if length(var.passengers) == 0 ~}
No passengers tonight.
%{ else ~}
Total: ${length(var.passengers)}
%{ endif ~}
EOT
}

resource "local_file" "manifest" {
  filename = "${path.module}/manifests/sleeper.txt"
  content  = local.manifest
}

output "manifest" {
  value = local.manifest
}
