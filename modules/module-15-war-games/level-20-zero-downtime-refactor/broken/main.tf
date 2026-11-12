# Pennywhistle Dairy - milkhouse control plane, after the "module tree" refactor (PR #88).
#
# The refactor split the old flat root into modules/. The running dairy was built by the old
# flat code: vat serials, room capacities, the dairy licence, the first-churn
# timestamp, the CIP cleaning cycle, a scratch "trial batch" and a rennet module called "rennet".
# This is the new code only; nobody has described the moves yet.

module "milkhouse" {
  source  = "./modules/milkhouse"
  vats = ["curd", "whey", "cold1", "cold2"]
}

module "caves" {
  source     = "./modules/caves"
  rooms = ["r1", "r2", "r3"]
}

module "compliance" {
  source = "./modules/compliance"
}

module "cultures" {
  source = "./modules/cultures"
}

resource "local_file" "dairy_sheet" {
  filename = "${path.module}/out/dairy-sheet.txt"
  content = join("\n", concat(
    [for k in sort(keys(module.milkhouse.serials)) : "vat ${k} ${module.milkhouse.serials[k]}"],
    sort([for k, v in module.caves.shelves : "room ${k} ${v}"]),
    [
      "licence ${module.compliance.licence}",
      "first churn ${module.compliance.first_churn}",
      "cip ${module.caves.cip_id}",
    ],
    [for k in sort(keys(module.cultures.strains)) : "rennet ${k} ${module.cultures.strains[k]}"],
    [""],
  ))
}

output "dairy_sheet_path" {
  value = local_file.dairy_sheet.filename
}
