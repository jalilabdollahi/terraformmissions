variable "dishes" {
  type    = list(string)
  default = ["smoked salmon", "reindeer stew", "cloudberry cream"]
}

module "kitchen" {
  source = "./modules/kitchen"

  dishes = var.dishes
}

output "courses" {
  value = module.kitchen.course_count
}
