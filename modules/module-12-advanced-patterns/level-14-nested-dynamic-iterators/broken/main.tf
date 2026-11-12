# Oak & Awl leathercraft studio: the tooling kit sent to each workshop.
# Every workshop owns a list of pieces. The kit is one zip with one entry per piece,
# stored as <workshop>/<piece>.txt. Two loops are nested here: the workshop loop and the
# piece loop inside it, and then a dynamic block turns the flattened result into zip entries.
# (The archive provider has no block-inside-block resource, so the nesting lives in the
# for expressions that feed the dynamic block.)

variable "workshops" {
  type = map(object({
    pieces = list(string)
  }))
  default = {
    north = { pieces = ["belt", "wallet"] }
    east  = { pieces = ["satchel"] }
  }
}

locals {
  stitch_sheets = flatten([
    for shop, spec in var.workshops : [
      for shop, piece in spec.pieces : {
        path    = "${shop}/${piece}.txt"
        content = "stitch sheet for ${piece}\n"
      }
    ]
  ])
}

data "archive_file" "kit" {
  type        = "zip"
  output_path = "${path.module}/kits/tooling-kit.zip"

  dynamic "source" {
    for_each = local.stitch_sheets
    iterator = sheet

    content {
      filename = source.value.path
      content  = source.value.content
    }
  }
}

output "kit_path" {
  value = data.archive_file.kit.output_path
}
