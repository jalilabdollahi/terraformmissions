#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record cocoa_lot_id "$(tm_state_attr random_id.cocoa_lot id)"
# --- Five things happen on the floor while nobody is looking ---------------
# 1. Kettle A: a night-shift tech fat-fingers the chill time.
python3 - <<'PY'
import pathlib
p = pathlib.Path("kettles/kettle-a.cfg")
p.write_text(p.read_text().replace("= 40", "= 4"))
PY
# 2. Kettle B: the config file is deleted during a PLC swap.
rm -f kettles/kettle-b.cfg
# 3. Dark-chocolate temper recipe: the quality lab approves a hotter melt; the foreman edits the live file.
cat > recipes/dark-temper.cfg <<'TXT'
# HOTFIX INC-4471 (R. Okafor): the quality lab signed off 122 F, permanent from this campaign.
couverture     = couverture-dark70
melt_temp_f   = 122
TXT
# 4. Mold C is scrapped, the tooling goes back to the mould store, the file is removed.
rm -f molds/mold-c.cfg
# 5. In the panic somebody taints the cocoa lot "to be safe" - wrappers already went out.
terraform taint random_id.cocoa_lot >/dev/null
exit 0
