variable "dishes" {
  type    = list(string)
  default = ["smoked salmon", "reindeer stew", "cloudberry cream"]
}

module "galley" {
  source = "./modules/galley"

  dishes = var.dishes
}

output "courses" {
  value = module.galley.course_count
}
