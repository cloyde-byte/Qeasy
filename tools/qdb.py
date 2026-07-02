#!/usr/bin/env python3
"""Fælles opslagsmodul mod pfQuest TBC-databasen (MIT, © Shagu)."""
import lupa

import os
PF = os.environ.get("PFQUEST_DB", os.path.join(os.path.dirname(__file__), "pfquest", "db"))

AREA_TO_UIMAP = {
    4: 1419, 3483: 1944, 3521: 1946, 3519: 1952, 3518: 1951,
    3522: 1949, 3523: 1953, 3520: 1948, 3703: 1955,
    1637: 1454,  # Orgrimmar
}

lua = lupa.LuaRuntime()
lua.execute("pfDB = { quests = {}, units = {}, objects = {}, zones = {}, items = {} }")
for f in ["quests-tbc.lua", "units-tbc.lua", "objects-tbc.lua", "items-tbc.lua",
          "enUS/quests.lua", "enUS/quests-tbc.lua",
          "enUS/units.lua", "enUS/units-tbc.lua",
          "enUS/objects.lua", "enUS/objects-tbc.lua"]:
    lua.execute(open(f"{PF}/{f}", encoding="utf-8", errors="replace").read())

pfDB = lua.globals().pfDB
qdata = pfDB["quests"]["data-tbc"]
qloc, qloc_v = pfDB["quests"]["enUS-tbc"], pfDB["quests"]["enUS"]
udata = pfDB["units"]["data-tbc"]
uloc, uloc_v = pfDB["units"]["enUS-tbc"], pfDB["units"]["enUS"]
odata = pfDB["objects"]["data-tbc"]
oloc, oloc_v = pfDB["objects"]["enUS-tbc"], pfDB["objects"]["enUS"]
idata = pfDB["items"]["data-tbc"]

T = lupa.lua_type


def loc_name(loc, loc_v, i):
    v = loc[i]
    if v is None or (isinstance(v, str) and v == "_"):
        v = loc_v[i]
    return str(v) if v is not None else f"#{i}"


def title(qid):
    e = qloc[qid]
    if e is None or (isinstance(e, str) and e == "_"):
        e = qloc_v[qid]
    if e is not None and T(e) == "table" and e["T"]:
        return str(e["T"])
    return None


def spawns(data, i):
    e = data[i]
    if e is None or T(e) != "table" or not e["coords"]:
        return []
    out = []
    for c in e["coords"].values():
        m = AREA_TO_UIMAP.get(int(c[3] or 0))
        if m:
            out.append((m, float(c[1]), float(c[2])))
    return out


def centroid(pts, prefer_map=None):
    if not pts:
        return None
    by = {}
    for m, x, y in pts:
        by.setdefault(m, []).append((x, y))
    m = prefer_map if prefer_map in by else max(by, key=lambda k: len(by[k]))
    lst = by[m]
    return (m, round(sum(p[0] for p in lst) / len(lst), 1),
            round(sum(p[1] for p in lst) / len(lst), 1))


def endpoint(node, prefer_map=None):
    """(navn, (map,x,y)) for en start/slut-node."""
    if not node:
        return None
    if node["U"]:
        for uid in node["U"].values():
            uid = int(uid)
            c = centroid(spawns(udata, uid), prefer_map)
            if c:
                return (loc_name(uloc, uloc_v, uid), c)
        uid = int(list(node["U"].values())[0])
        return (loc_name(uloc, uloc_v, uid), None)
    if node["O"]:
        for oid in node["O"].values():
            oid = int(oid)
            c = centroid(spawns(odata, oid), prefer_map)
            if c:
                return (loc_name(oloc, oloc_v, oid), c)
    if node["I"]:
        return ("(item)", None)
    return None


def objective_area(qid, prefer_map=None):
    """Centroid for quest-objectives: kill-units, objekter og item-kilder."""
    q = qdata[qid]
    if T(q) != "table" or not q["obj"]:
        return None
    pts = []
    obj = q["obj"]
    if obj["U"]:
        for uid in obj["U"].values():
            pts += spawns(udata, int(uid))
    if obj["O"]:
        for oid in obj["O"].values():
            pts += spawns(odata, int(oid))
    if obj["I"] and not pts:
        for iid in obj["I"].values():
            it = idata[int(iid)]
            if it is not None and T(it) == "table":
                if it["U"]:
                    for uid in it["U"].keys():
                        pts += spawns(udata, int(uid))
                if it["O"]:
                    for oid in it["O"].keys():
                        pts += spawns(odata, int(oid))
    return centroid(pts, prefer_map)


def info(qid, prefer_map=None):
    q = qdata[qid]
    if q is None or T(q) != "table":
        return None
    return {
        "id": qid,
        "title": title(qid),
        "min": q["min"] and int(q["min"]),
        "lvl": q["lvl"] and int(q["lvl"]),
        "race": q["race"] and int(q["race"]),
        "start": endpoint(q["start"], prefer_map),
        "end": endpoint(q["end"], prefer_map),
        "obj": objective_area(qid, prefer_map),
        "pre": sorted(int(p) for p in q["pre"].values()) if q["pre"] else [],
    }
