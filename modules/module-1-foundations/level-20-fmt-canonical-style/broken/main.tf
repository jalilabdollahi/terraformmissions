# Line 7 tram timetable, generated for the depot noticeboard.
variable "line" {
    type = string
	default = "7"
}

locals {
  first_departure="05:40"
  headway_min   =   12
    stops = ["Harbour Gate","Old Mill","Clocktower","University"]
}

resource "local_file" "timetable" {
 filename = "${path.module}/depot/line-${var.line}.txt"
    content = join("\n",concat(
  ["Line ${var.line}: first tram ${local.first_departure}, every ${local.headway_min} min"],
      [for i, s in local.stops : "${i + 1}. ${s}"],
      [""]
  ))
}
