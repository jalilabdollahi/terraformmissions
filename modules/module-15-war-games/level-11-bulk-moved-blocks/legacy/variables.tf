variable "loaders" {
  type    = list(string)
  default = ["LD-1", "LD-2", "LD-3", "LD-4", "LD-5", "LD-6"]
}

variable "stands" {
  type    = list(string)
  default = ["C3", "A1", "B2", "G7", "D4", "F6", "E5"]
}

variable "dock_doors" {
  type    = list(string)
  default = ["out-1", "in-1", "in-2", "out-2", "in-3"]
}
