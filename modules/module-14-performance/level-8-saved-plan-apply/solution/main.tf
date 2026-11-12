# Ludlow County Court: hearing docket, one file per case.

variable "hearings" {
  type = map(string)
  default = {
    "c-3011" = "Hartnell v. Quayle, 2026-03-04, Court 2"
    "c-3012" = "Re: Marchbank Estate, 2026-03-04, Court 1"
    "c-3013" = "Orrin Mills v. County Roads, 2026-03-05, Court 2"
    "c-3014" = "Pell v. Pell, 2026-03-06, Court 3"
    "c-3015" = "Tidewater Co-op, licence review, 2026-03-06, Court 1"
  }
}

resource "local_file" "docket" {
  for_each = var.hearings
  filename = "${path.module}/docket/${each.key}.txt"
  content  = "Case ${each.key}: ${each.value}\n"
}

output "docketed" {
  value = sort(keys(local_file.docket))
}
