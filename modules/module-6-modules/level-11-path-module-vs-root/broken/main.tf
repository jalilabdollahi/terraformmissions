variable "stop" {
  type    = string
  default = "haunted-cellar"
}

variable "narrator" {
  type    = string
  default = "Edith"
}

module "guide" {
  source = "./modules/guide"

  stop     = var.stop
  narrator = var.narrator
}

output "audio_file" {
  value = module.guide.script_path
}
