# Seaweed farm: every longline has a sample sheet in samples/. One data source instance per sheet.

data "local_file" "sample" {
  for_each = fileset("${path.module}/samples", "*.txt")
  filename = each.value
}

locals {
  growth = {
    for key, sheet in data.local_file.sample :
    key => tonumber(regex("growth: ([0-9.]+)", sheet.content)[0])
  }
  all_sheets = data.local_file.sample[*].content
}

resource "local_file" "farm_board" {
  filename = "${path.module}/farm/board.txt"
  content = join("\n", concat(
    [for id, b in local.growth : "${id}: ${b} cm"],
    ["Longlines sampled: ${length(local.all_sheets)}", ""]
  ))
}

output "growth" {
  value = local.growth
}

output "average_growth" {
  value = format("%.2f", sum(values(local.growth)) / length(local.growth))
}
