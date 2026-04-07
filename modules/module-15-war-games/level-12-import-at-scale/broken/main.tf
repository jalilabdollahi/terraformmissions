# 5 resources to import. 2 have wrong IDs.
# For random_string, the import ID is the result string itself.
# BUG: import block for res_b uses "wrong-id-b" instead of "tokenb001"
# BUG: import block for res_d uses "wrong-id-d" instead of "tokend001"

import {
  id = "tokena001"
  to = random_string.res_a
}

import {
  id = "wrong-id-b"
  to = random_string.res_b
}

import {
  id = "tokenc001"
  to = random_string.res_c
}

import {
  id = "wrong-id-d"
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
