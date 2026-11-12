# Pennywhistle Clockwork Carousel Works - workshop control plane, after the "module tree" refactor (PR #88).
#
# The refactor split the old flat root into modules/. The running works was built by the old
# flat code: spring serials, stall load ratings, the ride licence, the first-spin
# timestamp, the oiling cycle, a scratch "prototype run" and a paint module called "paint".
# This is the new code only; nobody has described the moves yet.

module "movements" {
  source  = "./modules/movements"
  springs = ["brass", "steel", "coil1", "coil2"]
}

module "stables" {
  source     = "./modules/stables"
  stalls = ["h1", "h2", "h3"]
}

module "compliance" {
  source = "./modules/compliance"
}

module "finishes" {
  source = "./modules/finishes"
}

resource "local_file" "works_sheet" {
  filename = "${path.module}/out/works-sheet.txt"
  content = join("\n", concat(
    [for k in sort(keys(module.movements.serials)) : "spring ${k} ${module.movements.serials[k]}"],
    sort([for k, v in module.stables.loads : "stall ${k} ${v}"]),
    [
      "licence ${module.compliance.licence}",
      "first spin ${module.compliance.first_spin}",
      "oil ${module.stables.oil_id}",
    ],
    [for k in sort(keys(module.finishes.coats)) : "paint ${k} ${module.finishes.coats[k]}"],
    [""],
  ))
}

output "works_sheet_path" {
  value = local_file.works_sheet.filename
}
