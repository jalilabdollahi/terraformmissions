variable "sections" {
  type = map(number)
  default = {
    soprano = 12
    alto    = 9
    tenor   = 6
    bass    = 7
  }
}

module "section" {
  source   = "./modules/section"
  for_each = var.sections

  voice   = each.key
  singers = each.value
}

output "rehearsal_minutes" {
  value = { for voice, m in module.section : voice => m.minutes }
}

output "total_minutes" {
  value = sum([for m in module.section : m.minutes])
}
