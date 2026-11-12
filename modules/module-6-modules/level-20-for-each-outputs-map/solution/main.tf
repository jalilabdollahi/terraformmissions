variable "classes" {
  type = map(number)
  default = {
    vinyasa  = 12
    hatha    = 9
    yin      = 6
    ashtanga = 7
  }
}

module "classroom" {
  source   = "./modules/classroom"
  for_each = var.classes

  style    = each.key
  students = each.value
}

output "prep_minutes" {
  value = { for style, m in module.classroom : style => m.minutes }
}

output "total_minutes" {
  value = sum([for m in module.classroom : m.minutes])
}
