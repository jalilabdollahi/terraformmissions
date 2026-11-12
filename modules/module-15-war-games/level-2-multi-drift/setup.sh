#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record heat_lot_id "$(tm_state_attr random_id.heat_lot id)"
# --- Five things happen on the floor while nobody is looking ---------------
# 1. Furnace A: a night-shift tech fat-fingers the quench time.
python3 - <<'PY'
import pathlib
p = pathlib.Path("furnaces/furnace-a.cfg")
p.write_text(p.read_text().replace("= 40", "= 4"))
PY
# 2. Furnace B: the config file is deleted during a PLC swap.
rm -f furnaces/furnace-b.cfg
# 3. Bronze pour recipe: metallurgy approves a hotter pour; the foreman edits the live file.
cat > recipes/bronze-pour.cfg <<'TXT'
# HOTFIX INC-4471 (R. Okafor): metallurgy signed off 1450 C, permanent from this campaign.
alloy         = bronze-b10
pour_temp_c   = 1450
TXT
# 4. Mold C is scrapped, the tooling goes back to the pattern shop, the file is removed.
rm -f molds/mold-c.cfg
# 5. In the panic somebody taints the heat lot "to be safe" - stamps already went out.
terraform taint random_id.heat_lot >/dev/null
exit 0
