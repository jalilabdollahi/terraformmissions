variable "carts" {
  type    = list(string)
  default = ["CT-1", "CT-2", "CT-3", "CT-4", "CT-5", "CT-6"]
}

variable "lots" {
  type    = list(string)
  default = ["C3", "A1", "B2", "G7", "D4", "F6", "E5"]
}

variable "dock_doors" {
  type    = list(string)
  default = ["out-1", "in-1", "in-2", "out-2", "in-3"]
}
