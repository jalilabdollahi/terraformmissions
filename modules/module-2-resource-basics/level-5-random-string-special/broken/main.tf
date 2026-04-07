# BUG: special = true but override_special = "" means special chars must come
# from an empty set — impossible, causing an error at apply time.

resource "random_string" "password" {
  length           = 12
  special          = true
  override_special = ""
}
