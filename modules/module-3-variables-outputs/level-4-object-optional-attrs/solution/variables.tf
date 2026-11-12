variable "cafe_name" {
  type    = string
  default = "Quill & Kettle"
}

variable "drinks" {
  description = "Menu entries. Size is optional on the paper menu: most drinks come in one size."
  type = list(object({
    name  = string
    price = number
    size  = optional(string, "regular")
  }))
}
