variable "output_dir" {
  description = "Folder that receives the printed menu."
  type        = string
}

variable "items" {
  description = "Items on the menu."
  type        = list(string)
}
