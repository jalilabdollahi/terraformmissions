import {
  id = "tokena001"
  to = random_string.res_a
}

import {
  id = "tokenb001"
  to = random_string.res_b
}

import {
  id = "tokenc001"
  to = random_string.res_c
}

import {
  id = "tokend001"
  to = random_string.res_d
}

import {
  id = "tokene001"
  to = random_string.res_e
}

resource "random_string" "res_a" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "res_b" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "res_c" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "res_d" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "res_e" {
  length  = 8
  special = false
  upper   = false
}

output "all_ids" {
  value = [
    random_string.res_a.result,
    random_string.res_b.result,
    random_string.res_c.result,
    random_string.res_d.result,
    random_string.res_e.result,
  ]
}
