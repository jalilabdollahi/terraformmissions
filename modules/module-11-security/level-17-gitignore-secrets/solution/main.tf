# The stall roster of the Emberfall hot-sauce festival. A pre-commit step also prints the
# repository's active ignore rules so reviewers can see what is (not) being committed.
variable "festival" {
  type    = string
  default = "Emberfall Chilli Weekend"
}

variable "stalls" {
  type    = list(string)
  default = ["smoky-habanero", "verde-fire", "ghost-pepper-co"]
}

locals {
  ignore_rules = [
    for line in split("\n", file("${path.module}/.gitignore")) : trimspace(line)
    if trimspace(line) != "" && !startswith(trimspace(line), "#")
  ]
}

resource "local_file" "stall_roster" {
  filename = "${path.module}/festival/stalls.txt"
  content  = "${var.festival}\n${join("\n", var.stalls)}\n"
}

resource "local_file" "ignore_audit" {
  filename = "${path.module}/reports/ignore-audit.txt"
  content  = "ignore rules: ${length(local.ignore_rules)}\n${join("\n", local.ignore_rules)}\n"
}
