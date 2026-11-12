# Tansy & Tin tea merchants — pack labels for the loose-leaf range.
# Every blend starts from the house label; the blend's own entries win where they overlap.
# Allergen warnings from the house list and the blend are combined, without repeats.

variable "house_label" {
  type = map(string)
  default = {
    origin   = "Assam"
    grade    = "OP"
    pack     = "50g tin"
    steep    = "4 min"
  }
}

variable "blend_label" {
  type = map(string)
  default = {
    grade = "BOP"
    pack  = "100g pouch"
  }
}

variable "house_allergens" {
  type    = list(string)
  default = ["nuts", "sesame"]
}

variable "blend_allergens" {
  type    = list(string)
  default = ["sesame", "soy"]
}

locals {
  label     = merge(var.blend_label, var.house_label)
  allergens = merge(var.house_allergens, var.blend_allergens)
}

resource "local_file" "pack_label" {
  filename = "${path.module}/labels/pack.txt"
  content = "${join("\n", concat(
    [for k, v in local.label : "${k}: ${v}"],
    ["contains: ${join(", ", local.allergens)}"],
  ))}\n"
}

output "label" {
  value = local.label
}

output "allergens" {
  value = local.allergens
}
