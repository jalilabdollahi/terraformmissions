# Vineyard cellar: every barrel has a sample sheet in samples/. One data source instance per sheet.

data "local_file" "sample" {
  for_each = fileset("${path.module}/samples", "*.txt")
  filename = each.value
}

locals {
  brix = {
    for key, sheet in data.local_file.sample :
    key => tonumber(regex("brix: ([0-9.]+)", sheet.content)[0])
  }
  all_sheets = data.local_file.sample[*].content
}

resource "local_file" "cellar_board" {
  filename = "${path.module}/cellar/board.txt"
  content = join("\n", concat(
    [for id, b in local.brix : "${id}: ${b} brix"],
    ["Barrels sampled: ${length(local.all_sheets)}", ""]
  ))
}

output "brix" {
  value = local.brix
}

output "average_brix" {
  value = format("%.2f", sum(values(local.brix)) / length(local.brix))
}
