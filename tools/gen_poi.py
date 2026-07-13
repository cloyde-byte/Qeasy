#!/usr/bin/env python3
"""Generér Data/OutlandPOI.lua: kroværter (innkeepers) og postkasser (mailboxes)
i Outland, fra pfQuests meta-tbc.lua (MIT, © Shagu) - a la Questie.

  innkeepers[map] = { {x, y, "navn"}, ... }   (Horde + neutrale units)
  mailboxes[map]  = { {x, y}, ... }           (Horde + neutrale objekter)
"""
import os
import qdb

OUTLAND = {1944, 1946, 1952, 1951, 1949, 1953, 1948, 1955}

qdb.lua.execute(open(os.path.join(qdb.PF, "meta-tbc.lua"), encoding="utf-8").read())
meta = qdb.pfDB["meta-tbc"]


def esc(s):
    return str(s).replace("\\", "\\\\").replace('"', '\\"')


def collect_innkeepers():
    by_map = {}
    for k, fac in meta["innkeeper"].items():
        if "H" not in str(fac):           # kun Horde/neutral (H, AH)
            continue
        uid = int(k)
        pts = [p for p in qdb.spawns(qdb.udata, uid) if p[0] in OUTLAND]
        if not pts:
            continue
        m, x, y = qdb.centroid(pts)
        name = qdb.loc_name(qdb.uloc, qdb.uloc_v, uid)
        by_map.setdefault(m, []).append((round(x, 1), round(y, 1), name))
    return by_map


def collect_mailboxes():
    by_map = {}
    for k, fac in meta["mailbox"].items():
        if "H" not in str(fac):           # kun Horde/neutral
            continue
        oid = abs(int(k))                 # postkasser gemmes som negative objekt-id
        pts = [p for p in qdb.spawns(qdb.odata, oid) if p[0] in OUTLAND]
        if not pts:
            continue
        m, x, y = qdb.centroid(pts)
        by_map.setdefault(m, []).append((round(x, 1), round(y, 1)))
    return by_map


def main():
    ik = collect_innkeepers()
    mb = collect_mailboxes()
    out_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "Data")
    os.makedirs(out_dir, exist_ok=True)
    path = os.path.join(out_dir, "OutlandPOI.lua")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write("local _, ns = ...\n")
        fh.write("-- GENERERET af tools/gen_poi.py fra pfQuest (MIT, (c) Shagu). "
                 "Rediger ikke i hånden.\n")
        fh.write("-- Kroværter og postkasser i Outland (Horde + neutrale).\n")
        fh.write("ns.POI = {\n")
        fh.write("  innkeepers = {\n")
        for m in sorted(ik):
            fh.write("    [%d] = {\n" % m)
            for x, y, name in sorted(ik[m]):
                fh.write('      {%.1f, %.1f, "%s"},\n' % (x, y, esc(name)))
            fh.write("    },\n")
        fh.write("  },\n")
        fh.write("  mailboxes = {\n")
        for m in sorted(mb):
            fh.write("    [%d] = {\n" % m)
            for x, y in sorted(mb[m]):
                fh.write("      {%.1f, %.1f},\n" % (x, y))
            fh.write("    },\n")
        fh.write("  },\n")
        fh.write("}\n")
    ni = sum(len(v) for v in ik.values())
    nm = sum(len(v) for v in mb.values())
    print(f"{path}: {ni} kroværter, {nm} postkasser")


if __name__ == "__main__":
    main()
