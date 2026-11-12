# Cooper's Ridge pigeon loft: three registry values that already exist on paper
# (see loft-register.csv) and must be adopted. Every provider chooses its own import ID
# format, and the IDs below were typed in whatever format seemed natural.

resource "random_integer" "ring" {
  min = 100
  max = 999
}

resource "time_static" "release" {
  rfc3339  = "2025-04-12T06:30:00Z"
  triggers = {}
}

resource "random_id" "loft" {
  byte_length = 4
}

import {
  to = random_integer.ring
  id = "212"
}

import {
  to = time_static.release
  id = "1744439400"
}

import {
  to = random_id.loft
  id = "5a4c8b0f"
}

resource "local_file" "certificate" {
  filename = "${path.module}/loft/certificate.txt"
  content  = "ring ${random_integer.ring.result}, released ${time_static.release.rfc3339}, loft ${random_id.loft.b64_url}\n"
}
