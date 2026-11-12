variable "loaders" {
  description = "Cargo loaders at Nordhavn"
  type        = list(string)
  default     = ["LD-1", "LD-2", "LD-3", "LD-4", "LD-5", "LD-6"]
}

variable "stands" {
  description = "Aircraft stands on the apron"
  type        = list(string)
  default     = ["A1", "B2", "C3", "D4", "E5", "F6", "G7"]
}

variable "dock_doors" {
  description = "Truck dock doors"
  type        = list(string)
  default     = ["in-1", "in-2", "in-3", "out-1", "out-2"]
}
