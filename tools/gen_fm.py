#!/usr/bin/env python3
"""Generér Data/OutlandFlightMasters.lua fra pfQuest.

pfQuests meta-tbc.lua har en "flight"-kategori: flight master-NPC-id -> faction
("A"/"H"/"AH"). Vi tager de Horde-brugbare (H + AH), slår deres Outland-spawn
op i units-databasen, og skriver en tabel { [map] = { {x,y,navn,horde}, ... } }.
"""
import os
import qdb

OUTLAND = {1944, 1946, 1952, 1951, 1949, 1953, 1948, 1955}

# indlæs meta-tbc i qdb's lua-runtime
qdb.lua.execute(open(os.path.join(qdb.PF, "meta-tbc.lua"), encoding="utf-8").read())
flight = qdb.pfDB["meta-tbc"]["flight"]


def main():
    by_map = {}
    n = 0
    for nid, fac in flight.items():
        nid = int(nid)
        fac = str(fac)
        if "H" not in fac:          # kun Horde-brugbare (H eller AH)
            continue
        pts = [p for p in qdb.spawns(qdb.udata, nid) if p[0] in OUTLAND]
        if not pts:
            continue
        m, x, y = qdb.centroid(pts)
        name = qdb.loc_name(qdb.uloc, qdb.uloc_v, nid)
        horde = "true" if fac == "H" else "false"   # AH = neutral
        by_map.setdefault(m, []).append((round(x, 1), round(y, 1), name, horde))
        n += 1

    out_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "Data")
    os.makedirs(out_dir, exist_ok=True)
    path = os.path.join(out_dir, "OutlandFlightMasters.lua")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write("local _, ns = ...\n")
        fh.write("-- GENERERET af tools/gen_fm.py fra pfQuest (MIT, (c) Shagu). "
                 "Rediger ikke i hånden.\n")
        fh.write("-- Outland flight masters (Horde + neutrale). "
                 "{x, y, navn, erHorde}\n")
        fh.write("ns.FlightMasters = {\n")
        for m in sorted(by_map):
            fh.write("  [%d] = {\n" % m)
            for x, y, name, horde in sorted(by_map[m]):
                name = name.replace("\\", "\\\\").replace('"', '\\"')
                fh.write('    {%.1f, %.1f, "%s", %s},\n' % (x, y, name, horde))
            fh.write("  },\n")
        fh.write("}\n")
    print(f"{path}: {n} flight masters på {len(by_map)} kort")
    for m in sorted(by_map):
        print(f"  map {m}: {len(by_map[m])}")


if __name__ == "__main__":
    main()
