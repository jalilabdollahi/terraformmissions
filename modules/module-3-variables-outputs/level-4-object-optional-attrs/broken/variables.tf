variable "parlour_name" {
  type    = string
  default = "Frosty Spoon"
}

variable "flavours" {
  description = "Menu entries. Size is optional on the paper menu: most flavours come in one size."
  type = list(object({
    name  = string
    price = number
    size  = string
  }))
}
