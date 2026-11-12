# Lighting team. Reads the stage contract and refuses an incompatible major version.

resource "local_file" "lighting_cue" {
  filename = "${path.module}/rigs/lighting.txt"
  content  = "Lighting rig on ${module.stage.stage_contract.stage_id}: budget ${module.stage.stage_contract.power_budget_kw} kW (contract ${module.stage.stage_contract.version})\n"

  lifecycle {
    precondition {
      condition     = startswith(module.stage.stage_contract.version, "2.")
      error_message = "lighting supports stage contract 2.x only, the stage module published ${module.stage.stage_contract.version}"
    }
  }
}
