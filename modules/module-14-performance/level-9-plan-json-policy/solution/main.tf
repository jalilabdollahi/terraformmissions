# Saltreach bonded warehouse: one manifest per lot. This config is compliant;
# the gate script is what needs work.

variable "lots" {
  type = map(string)
  default = {
    "lot-0412" = "green coffee, 120 sacks"
    "lot-0413" = "olive oil, 40 drums"
    "lot-0419" = "saffron, 2 crates"
    "lot-0424" = "tea chests, 300"
  }
}

resource "local_file" "manifest" {
  for_each        = var.lots
  filename        = "${path.module}/bonded/${each.key}.txt"
  content         = "${each.key}: ${each.value}\n"
  file_permission = "0640"
}
