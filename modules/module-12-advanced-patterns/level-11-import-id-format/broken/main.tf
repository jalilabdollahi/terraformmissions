# Cooper's Ridge turtle hatchery: three registry values that already exist on paper
# (see nest-register.csv) and must be adopted. Every provider chooses its own import ID
# format, and the IDs below were typed in whatever format seemed natural.

resource "random_integer" "tag" {
  min = 100
  max = 999
}

resource "time_static" "release" {
  rfc3339  = "2025-04-12T06:30:00Z"
  triggers = {}
}

resource "random_id" "nest" {
  byte_length = 4
}

import {
  to = random_integer.tag
  id = "212"
}

import {
  to = time_static.release
  id = "1744439400"
}

import {
  to = random_id.nest
  id = "5a4c8b0f"
}

resource "local_file" "certificate" {
  filename = "${path.module}/hatchery/certificate.txt"
  content  = "tag ${random_integer.tag.result}, released ${time_static.release.rfc3339}, nest ${random_id.nest.b64_url}\n"
}
