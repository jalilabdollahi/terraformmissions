variable "exhibit" {
  type    = string
  default = "steam-loco"
}

variable "narrator" {
  type    = string
  default = "Edith"
}

module "guide" {
  source = "./modules/guide"

  exhibit  = var.exhibit
  narrator = var.narrator
}

output "audio_file" {
  value = module.guide.script_path
}
