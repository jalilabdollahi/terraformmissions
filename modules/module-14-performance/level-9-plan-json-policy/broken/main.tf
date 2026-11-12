# Glenmorrow whisky bonded warehouse: one manifest per cask. This config is compliant;
# the gate script is what needs work.

variable "casks" {
  type = map(string)
  default = {
    "cask-0412" = "single malt, 40 casks"
    "cask-0413" = "rye whisky, 30 casks"
    "cask-0419" = "grain spirit, 12 casks"
    "cask-0424" = "peated malt, 25 casks"
  }
}

resource "local_file" "manifest" {
  for_each        = var.casks
  filename        = "${path.module}/bonded/${each.key}.txt"
  content         = "${each.key}: ${each.value}\n"
  file_permission = "0640"
}
