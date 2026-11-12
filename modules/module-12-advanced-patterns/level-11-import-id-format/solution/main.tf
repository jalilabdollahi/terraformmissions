# Cooper's Ridge Message-in-a-Bottle Society: three register values that already exist on paper
# (see bottle-register.csv) and must be adopted. Every provider chooses its own import ID
# format, and the IDs below were typed in whatever format seemed natural.

resource "random_integer" "bottle" {
  min = 100
  max = 999
}

resource "time_static" "launch" {
  rfc3339  = "2025-04-12T06:30:00Z"
  triggers = {}
}

resource "random_id" "cork" {
  byte_length = 4
}

import {
  to = random_integer.bottle
  id = "212,100,999"
}

import {
  to = time_static.launch
  id = "2025-04-12T06:30:00Z"
}

import {
  to = random_id.cork
  id = "Yd4Pxg"
}

resource "local_file" "certificate" {
  filename = "${path.module}/society/certificate.txt"
  content  = "bottle ${random_integer.bottle.result}, launched ${time_static.launch.rfc3339}, cork ${random_id.cork.b64_url}\n"
}
