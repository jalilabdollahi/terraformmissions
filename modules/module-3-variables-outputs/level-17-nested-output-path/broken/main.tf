# Willowmere Zoo — habitat roster. The visitor app reads three outputs.

variable "habitats" {
  description = "Habitat key => details."
  type = map(object({
    diet = string
    enclosure = object({
      capacity = number
      keepers  = list(string)
    })
  }))
  default = {
    savanna = {
      diet = "grass"
      enclosure = {
        capacity = 12
        keepers  = ["Ana", "Raj"]
      }
    }
    aviary = {
      diet = "seeds"
      enclosure = {
        capacity = 40
        keepers  = ["Mei", "Tomas", "Lena"]
      }
    }
    reptile_house = {
      diet = "insects"
      enclosure = {
        capacity = 8
        keepers  = ["Omar"]
      }
    }
  }
}

resource "local_file" "roster" {
  for_each = var.habitats
  filename = "${path.module}/roster/${each.key}.txt"
  content  = "${each.key}: ${each.value.enclosure.capacity} animals, keepers ${join(" & ", each.value.enclosure.keepers)}\n"
}

output "savanna_capacity" {
  value = var.habitats["savanna"].capacity
}

output "aviary_lead_keeper" {
  value = var.habitats.aviary.enclosure.keeper[0]
}

output "reptile_head_keeper" {
  value = var.habitats["reptiles"].enclosure.keepers[0]
}

output "total_capacity" {
  value = sum([for h in values(var.habitats) : h.enclosure.capacity])
}
