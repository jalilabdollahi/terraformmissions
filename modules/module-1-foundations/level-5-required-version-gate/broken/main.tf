# Tide card for the Saltmarsh harbour office.
locals {
  tides = [
    { port = "Saltmarsh", high = "06:42", low = "12:55" },
    { port = "Gullcove", high = "07:10", low = "13:20" },
  ]
}

resource "local_file" "tide_card" {
  filename = "${path.module}/harbour/tides.csv"
  content = join("\n", concat(
    ["port,high,low"],
    [for t in local.tides : "${t.port},${t.high},${t.low}"],
    [""]
  ))
}

output "tide_rows" {
  value = length(local.tides)
}
