# Halcyon float warehouse stack - split plan (approved in CAB-4471)

The single `monolith/` state is being retired. Ownership after the split:

| Stack        | Owns                                                              | Reads from        |
|--------------|-------------------------------------------------------------------|-------------------|
| `warehouse/`     | dock key, rider capacity, the two float serials                   | -                 |
| `krewes/` | sign-up namespace, the bead series, the bead ledger file          | warehouse             |
| `lighting/` | lights key (formerly `rig_key`), the two controllers, the cue sheet   | warehouse, krewes  |

Rules agreed in the CAB:
- No object may be destroyed or re-issued: rider capacity and bead series are stamped on the float permits.
- Cross-stack values travel through `terraform_remote_state` (local backends, sibling directories).
- The three new configs are already scaffolded in this repo; they use the final resource names.
- The `monolith/` directory must end up empty of resources and of resource code.

Open item from review: `lighting` needs the gold bead series; confirm `krewes` exports it.
