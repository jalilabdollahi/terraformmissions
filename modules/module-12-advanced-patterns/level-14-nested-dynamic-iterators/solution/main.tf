# Ember & Lead stained glass studio: the cutting kit sent to each workshop.
# Every workshop owns a list of panels. The kit is one zip with one entry per panel,
# stored as <workshop>/<panel>.txt. Two loops are nested here: the workshop loop and the
# panel loop inside it, and then a dynamic block turns the flattened result into zip entries.
# (The archive provider has no block-inside-block resource, so the nesting lives in the
# for expressions that feed the dynamic block.)

variable "workshops" {
  type = map(object({
    panels = list(string)
  }))
  default = {
    north = { panels = ["rose-window", "lily"] }
    east  = { panels = ["sunburst"] }
  }
}

locals {
  cut_sheets = flatten([
    for shop, spec in var.workshops : [
      for _, panel in spec.panels : {
        path    = "${shop}/${panel}.txt"
        content = "cut sheet for ${panel}\n"
      }
    ]
  ])
}

data "archive_file" "kit" {
  type        = "zip"
  output_path = "${path.module}/kits/cutting-kit.zip"

  dynamic "source" {
    for_each = local.cut_sheets
    iterator = sheet

    content {
      filename = sheet.value.path
      content  = sheet.value.content
    }
  }
}

output "kit_path" {
  value = data.archive_file.kit.output_path
}
