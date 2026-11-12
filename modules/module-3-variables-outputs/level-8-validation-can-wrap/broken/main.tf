# Spoke & Pedal bike-share app — release tag gate.
# Release tags look like v3.12 (major.minor). The pipeline passes the tag in.
# The validation should give a friendly message when the tag is malformed,
# but ops say they just see a wall of regex errors.

variable "release_tag" {
  description = "App release tag, e.g. v3.12."
  type        = string
  default     = "v3.12"

  validation {
    condition     = regex("^v[0-9]+\\.[0-9]+$", var.release_tag) != ""
    error_message = "Release tags must look like v3.12 (a 'v', major number, dot, minor number)."
  }
}

locals {
  parts = regex("^v([0-9]+)\\.([0-9]+)$", var.release_tag)
}

resource "local_file" "release_notes_header" {
  filename = "${path.module}/release/HEADER.md"
  content  = "# Spoke & Pedal ${var.release_tag}\nMajor ${local.parts[0]}, minor ${local.parts[1]}\n"
}

output "major" {
  value = tonumber(local.parts[0])
}

output "minor" {
  value = tonumber(local.parts[1])
}
