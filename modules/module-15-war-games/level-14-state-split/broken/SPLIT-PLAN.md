# Halcyon opera house stack - split plan (approved in CAB-4471)

The single `monolith/` state is being retired. Ownership after the split:

| Stack        | Owns                                                              | Reads from        |
|--------------|-------------------------------------------------------------------|-------------------|
| `venue/`     | hall key, seat capacity, the two stage serials                   | -                 |
| `ticketing/` | booking namespace, the pass series, the ticket book file          | venue             |
| `streaming/` | stream key (formerly `cdn_key`), the two encoders, the playlist   | venue, ticketing  |

Rules agreed in the CAB:
- No object may be destroyed or re-issued: seat capacity and pass series are printed on tickets.
- Cross-stack values travel through `terraform_remote_state` (local backends, sibling directories).
- The three new configs are already scaffolded in this repo; they use the final resource names.
- The `monolith/` directory must end up empty of resources and of resource code.

Open item from review: `streaming` needs the gold pass series; confirm `ticketing` exports it.
