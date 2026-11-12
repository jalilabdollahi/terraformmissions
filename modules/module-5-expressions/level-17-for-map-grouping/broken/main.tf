# Port Selby Airport — which flights are announced on which baggage carousel.

variable "arrivals" {
  type = list(object({
    flight   = string
    carousel = string
  }))
  default = [
    { flight = "SB204", carousel = "C1" },
    { flight = "KL881", carousel = "C2" },
    { flight = "SB311", carousel = "C1" },
    { flight = "AE090", carousel = "C3" },
    { flight = "KL112", carousel = "C2" },
    { flight = "SB520", carousel = "C1" },
  ]
}

locals {
  by_carousel = { for a in var.arrivals : a.carousel => a.flight }
}

resource "local_file" "announcement" {
  for_each = local.by_carousel
  filename = "${path.module}/boards/${lower(each.key)}.txt"
  content  = "Carousel ${each.key}: ${join(", ", each.value)}\n"
}

output "by_carousel" {
  value = local.by_carousel
}

output "load" {
  value = { for carousel, flights in local.by_carousel : carousel => length(flights) }
}
