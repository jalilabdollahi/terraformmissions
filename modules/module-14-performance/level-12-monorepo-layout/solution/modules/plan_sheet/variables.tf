variable "unit" {
  type        = string
  description = "Name of the subsystem; becomes the file name."
}

variable "lines" {
  type        = list(string)
  description = "Lines of the plan sheet."
}

variable "out_dir" {
  type        = string
  description = "Directory the sheet is written to."
}
