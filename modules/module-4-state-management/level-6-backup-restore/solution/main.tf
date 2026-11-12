# Redline Motors: used-car stock list.
# An intern applied a branch without these three resources, then put the code back.
# Everything below is correct. Only the state lost the entries.

resource "random_pet" "sales_manager" {
  length    = 2
  separator = " "
}

resource "random_string" "bay_code" {
  length  = 6
  upper   = true
  lower   = false
  special = false
}

resource "random_integer" "stock_number" {
  min = 10000
  max = 99999
}

resource "local_file" "stock_index" {
  filename = "${path.module}/stock/index.txt"
  content  = <<-EOT
    Sales manager: ${random_pet.sales_manager.id}
    Bay code: ${random_string.bay_code.result}
    Next stock no: ${random_integer.stock_number.result}
  EOT
}
