# Lighting team. Reads the stage contract (once it exists).

resource "local_file" "lighting_cue" {
  filename = "${path.module}/rigs/lighting.txt"
  content  = "Lighting rig on ${module.stage.stage_contract.stage_id}: budget ${module.stage.stage_contract.power_budget_kw} kW (contract ${module.stage.stage_contract.version})\n"
}
