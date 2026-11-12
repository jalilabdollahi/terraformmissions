variable "carts" {
  description = "Cold-room carts at Nordhavn"
  type        = list(string)
  default     = ["CT-1", "CT-2", "CT-3", "CT-4", "CT-5", "CT-6"]
}

variable "lots" {
  description = "Auction lot positions on the clock-hall floor"
  type        = list(string)
  default     = ["A1", "B2", "C3", "D4", "E5", "F6", "G7"]
}

variable "dock_doors" {
  description = "Truck dock doors"
  type        = list(string)
  default     = ["in-1", "in-2", "in-3", "out-1", "out-2"]
}
