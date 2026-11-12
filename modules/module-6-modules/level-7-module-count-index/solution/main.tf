variable "posts_total" {
  type    = number
  default = 3
}

module "post" {
  source = "./modules/lamppost"
  count  = var.posts_total

  number = count.index + 1
}

output "labels" {
  value = module.post[*].label
}

output "last_label" {
  value = module.post[var.posts_total - 1].label
}
