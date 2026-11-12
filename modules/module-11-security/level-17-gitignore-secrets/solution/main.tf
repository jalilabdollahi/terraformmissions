# The sculpture roster of the Emberfall ice sculpture festival. A pre-commit step also prints the
# repository's active ignore rules so reviewers can see what is (not) being committed.
variable "festival" {
  type    = string
  default = "Emberfall Frostbite Weekend"
}

variable "sculptures" {
  type    = list(string)
  default = ["frozen-dragon", "aurora-arch", "polar-bear-pair"]
}

locals {
  ignore_rules = [
    for line in split("\n", file("${path.module}/.gitignore")) : trimspace(line)
    if trimspace(line) != "" && !startswith(trimspace(line), "#")
  ]
}

resource "local_file" "sculpture_roster" {
  filename = "${path.module}/festival/sculptures.txt"
  content  = "${var.festival}\n${join("\n", var.sculptures)}\n"
}

resource "local_file" "ignore_audit" {
  filename = "${path.module}/reports/ignore-audit.txt"
  content  = "ignore rules: ${length(local.ignore_rules)}\n${join("\n", local.ignore_rules)}\n"
}
