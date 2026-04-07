variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 10
}

resource "local_file" "config" {
  content  = "min=${var.min_size} max=${var.max_size}"
  filename = "${path.module}/size_config.txt"

  # Bug: condition is inverted — uses > instead of <
  # This passes when min > max (invalid) and fails when min < max (valid)
  lifecycle {
    precondition {
      condition     = var.min_size > var.max_size
      error_message = "min_size must be less than max_size."
    }
  }
}
