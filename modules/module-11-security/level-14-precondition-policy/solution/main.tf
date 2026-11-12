# Storage shelves of the Halloway newsreel film archive. Archive policy: every shelf keeps
# its material at least 30 days and no shelf is ever public.
variable "shelves" {
  type = map(object({
    retention_days = number
    public         = bool
  }))

  default = {
    intake  = { retention_days = 90, public = false }
    reels   = { retention_days = 365, public = false }
    ledger  = { retention_days = 45, public = false }
    lobby   = { retention_days = 60, public = false }
  }
}

resource "local_file" "shelf_manifest" {
  for_each = var.shelves

  filename = "${path.module}/shelves/${each.key}.manifest"
  content  = "shelf=${each.key}\nretention_days=${each.value.retention_days}\npublic=${each.value.public}\n"

  lifecycle {
    precondition {
      condition     = each.value.retention_days >= 30 && !each.value.public
      error_message = "Shelf ${each.key} violates archive policy: retention must be at least 30 days and the shelf must not be public."
    }
  }
}

output "shelf_names" {
  value = sort(keys(var.shelves))
}
