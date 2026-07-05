#!/usr/bin/env python3
"""Generér Data/OutlandQuests.lua: en quest-database til kort/minimap-ikoner.

Kun Outland (Hellfire, Zangarmarsh, Terokkar, Nagrand, Blade's Edge,
Netherstorm, Shadowmoon + Shattrath) og kun Horde/neutrale quests.

For hver quest gemmes (kompakte nøgler):
  t = titel
  g = giver-koordinat   {map, x, y}   (til '!' available-ikon)
  e = aflever-koordinat {map, x, y}   (til '?' turn-in-ikon)
  o = objektiv-koordinat {map, x, y}  (til aktive quest-ikoner)
  lvl = min-level, pre = {forudsætnings-quests}, race = race-maske

Data slås op i pfQuest (MIT, © Shagu). Kør fra tools/ med PFQUEST_DB sat.
"""
import os
import qdb

OUTLAND = {1944, 1946, 1952, 1951, 1949, 1953, 1948, 1955}
HORDE_MASK = 2 + 16 + 32 + 128 + 512
T = qdb.T


def outland_endpoint(node):
    """(navn, centroid) for en start/slut-node, begrænset til Outland."""
    if not node:
        return None, None
    if node["U"]:
        for uid in node["U"].values():
            uid = int(uid)
            pts = [p for p in qdb.spawns(qdb.udata, uid) if p[0] in OUTLAND]
            if pts:
                return qdb.loc_name(qdb.uloc, qdb.uloc_v, uid), qdb.centroid(pts)
    if node["O"]:
        for oid in node["O"].values():
            oid = int(oid)
            pts = [p for p in qdb.spawns(qdb.odata, oid) if p[0] in OUTLAND]
            if pts:
                return qdb.loc_name(qdb.oloc, qdb.oloc_v, oid), qdb.centroid(pts)
    return None, None


def _upts(src):
    p = []
    for uid in src.values():
        p += [x for x in qdb.spawns(qdb.udata, int(uid)) if x[0] in OUTLAND]
    return p


def _opts(src):
    p = []
    for oid in src.values():
        p += [x for x in qdb.spawns(qdb.odata, int(oid)) if x[0] in OUTLAND]
    return p


def outland_objective(qid):
    """Returnér (centroid, otype, pts). otype: 'u'=dræb enhed (sværd),
    'o'=interager/brug item (tandhjul), 'i'=saml genstand (tandhjul).
    pts = alle Outland-spawnpunkter for målet (til område-markering).

    Vigtigt: et objektiv med et påkrævet/udleveret item (IR) eller et objekt
    (O) er en INTERACT/brug-quest (tandhjul) - selv hvis der også er enheder
    (fx 'brug banner ved Boulderfist-lejre'). Kun rene enheds-mål = dræb."""
    q = qdb.qdata[qid]
    if T(q) != "table" or not q["obj"]:
        return None, None, None, None
    obj = q["obj"]

    # Brug-item (IR) eller interager-med-objekt (O) => tandhjul.
    if obj["IR"] or obj["O"]:
        pts = _opts(obj["O"]) if obj["O"] else []
        if not pts and obj["U"]:
            pts = _upts(obj["U"])          # fald tilbage på enheder for placering
        if pts:
            return qdb.centroid(pts), "o", pts, None

    # Rent enheds-mål => dræb (sværd). Gem også navnene på de enheder der
    # tæller (til mob-tooltips - fx kategori-mål som "Kil'sorrow Agent").
    if obj["U"]:
        pts, names = [], set()
        for uid in obj["U"].values():
            uid = int(uid)
            sp = [p for p in qdb.spawns(qdb.udata, uid) if p[0] in OUTLAND]
            if sp:
                pts += sp
                names.add(qdb.loc_name(qdb.uloc, qdb.uloc_v, uid))
        if pts:
            return qdb.centroid(pts), "u", pts, sorted(names)

    if obj["I"]:
        pts, from_unit = [], False
        for iid in obj["I"].values():
            it = qdb.idata[int(iid)]
            if it is not None and T(it) == "table":
                if it["U"]:
                    from_unit = True
                    for uid in it["U"].keys():
                        pts += [p for p in qdb.spawns(qdb.udata, int(uid)) if p[0] in OUTLAND]
                if it["O"]:
                    for oid in it["O"].keys():
                        pts += [p for p in qdb.spawns(qdb.odata, int(oid)) if p[0] in OUTLAND]
        if pts:
            # genstand fra en enhed = reelt et dræb; ellers indsamling
            return qdb.centroid(pts), ("u" if from_unit else "i"), pts, None
    return None, None, None, None


def build_area(pts, mapid, cap=24):
    """Nedsampl spawnpunkter (på målets kort) til en lille sky, der viser
    området. Grid-dedup så vi ikke gemmer hundredvis af punkter."""
    same = [(round(p[1], 1), round(p[2], 1)) for p in pts if p[0] == mapid]
    if len(same) < 2:
        return None
    seen, grid = set(), []
    for x, y in same:
        key = (round(x / 1.5), round(y / 1.5))
        if key in seen:
            continue
        seen.add(key)
        grid.append((x, y))
    if len(grid) < 2:
        return None
    if len(grid) > cap:
        step = len(grid) / cap
        grid = [grid[int(i * step)] for i in range(cap)]
    return ",".join("{%.1f,%.1f}" % (x, y) for x, y in grid)


def coord_lua(c):
    return "{%d,%.1f,%.1f}" % (c[0], c[1], c[2]) if c else "nil"


def main():
    rows = []
    n_total = 0
    for qid, q in qdb.qdata.items():
        if T(q) != "table":
            continue
        qid = int(qid)
        race = q["race"] and int(q["race"])
        if race and not (race & HORDE_MASK):
            continue  # ren Alliance
        giver_name, giver = outland_endpoint(q["start"])
        turnin_name, turnin = outland_endpoint(q["end"])
        obj, otype, opts, onames = outland_objective(qid)
        # medtag kun quests med mindst én Outland-koordinat
        if not (giver or turnin or obj):
            continue
        title = qdb.title(qid)
        if not title:
            continue
        n_total += 1
        pre = sorted(int(p) for p in q["pre"].values()) if q["pre"] else []

        def esc(s):
            return s.replace("\\", "\\\\").replace('"', '\\"')
        parts = ['t="%s"' % esc(title)]
        if giver:
            parts.append("g=" + coord_lua(giver))
            if giver_name:
                parts.append('gn="%s"' % esc(giver_name))
        if turnin:
            parts.append("e=" + coord_lua(turnin))
            if turnin_name:
                parts.append('en="%s"' % esc(turnin_name))
        if obj:
            parts.append("o=" + coord_lua(obj))
            if otype:
                parts.append('ot="%s"' % otype)
            area = build_area(opts, obj[0])
            if area:
                parts.append("oa={%s}" % area)
            # ou = navne på enheder der tæller (kun hvis de tilføjer noget ud
            # over selve titlen - fx kategori-mål). Sparer plads på de trivielle.
            if onames:
                extra = [n for n in onames if n and n not in title]
                if extra:
                    parts.append("ou={%s}" % ",".join('"%s"' % esc(n) for n in onames))
        if q["min"]:
            parts.append("lvl=%d" % int(q["min"]))
        if race:
            parts.append("race=%d" % race)
        if pre:
            parts.append("pre={%s}" % ",".join(str(p) for p in pre))
        rows.append((qid, "  [%d]={%s}," % (qid, ", ".join(parts))))

    rows.sort()
    out_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "Data")
    os.makedirs(out_dir, exist_ok=True)
    path = os.path.join(out_dir, "OutlandQuests.lua")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write("local _, ns = ...\n")
        fh.write("-- GENERERET af tools/gen_db.py fra pfQuest (MIT, (c) Shagu). "
                 "Rediger ikke i hånden.\n")
        fh.write("-- Outland quest-database til kort/minimap-ikoner. "
                 "Koordinater: {uiMapID, x, y}.\n")
        fh.write("ns.QuestDB = {\n")
        for _, line in rows:
            fh.write(line + "\n")
        fh.write("}\n")
    print(f"{path}: {len(rows)} quests ({os.path.getsize(path)//1024} KB)")


if __name__ == "__main__":
    main()
