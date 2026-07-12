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

# Sæson-/event-quests: de MEDTAGES nu i DB'en, men mærkes med et event-tag
# (`ev`), så de kun vises på kortet mens eventet er aktivt (dato-styret i
# Seasonal.lua). Fx Fire Festival kun i juni-juli, Candy Bucket kun til
# Hallow's End. Kurateret pr. titel (pfQuest har ingen event-data).
SEASON_EXACT = {
    "A Thief's Reward": "midsummer",
    "Candy Bucket": "hallowsend",
    "Accepting All Eggs": "noblegarden",
    "Of Thistleheads and Eggs...": "noblegarden",
    "Children's Week": "childrensweek",
}
SEASON_CONTAINS = [
    ("Honor the Flame", "midsummer"),
    ("Desecrate this Fire", "midsummer"),
    ("'s Flame", "midsummer"),              # Stealing X's Flame
    ("Playing with Fire", "midsummer"),
    ("Festival Scorchling", "midsummer"),
    ("Spinner of Summer Tales", "midsummer"),
    ("Torch Catching", "midsummer"),
    ("Torch Tossing", "midsummer"),
    ("Wickerman", "hallowsend"),
    ("Pumpkin", "hallowsend"),
    ("Hallow's End", "hallowsend"),
]


# Manuelle objektiv-koordinater for quests, hvor pfQuest ikke kan udlede stedet
# (fx "brug item"-quests hvis objektiv-enhed er en usynlig trigger uden spawns).
# { questID: (map, x, y, otype) }. otype: 'o'=interager/brug (tandhjul),
# 'u'=dræb (sværd). Udvid efter behov.
OBJ_OVERRIDE = {
    # Bladespire Kegger: gør Bladespire-ogrerne fulde ved Bladespire Hold.
    # Objektiv-enheden er en trigger uden spawns; ogrerne står ~(42,52).
    10545: (1949, 42.0, 52.5, "o"),
    # On Spirit's Wings: aflyt Bloodmaul-ogrerne. Objektiv-enheden er en usynlig
    # "[DND]Bloodmaul Chatter Credit"-trigger uden spawns; det par man skal aflytte
    # (Bloodmaul Taskmaster + Soothsayer) står i den østlige kløft ~(58,31).
    10714: (1949, 57.8, 31.1, "o"),
    # Gather the Orbs: saml Razaani Light Orbs. Objektiv-enheden er "Trapping the
    # Light Kill Credit Trigger" uden spawns; selve orb-NPC'en (unit 20635) står
    # tæt samlet ~(66.8,41.7) i Razaani-området (øst, mod Bash'ir Landing).
    10859: (1949, 66.8, 41.7, "o"),
}

# Manuelle PER-STED-markører (op) for quests med FLERE mål på hvert sit sted,
# hvor pfQuest ikke kan udlede stederne (trigger-enheder uden spawns).
# { questID: (otype, [(navn, map, x, y), ...]) }. `navn` skal matche STARTEN af
# objektiv-linjen i loggen, så markøren forsvinder når det delmål er klaret.
OP_OVERRIDE = {
    # A Curse Upon Both of Your Clans!: forband bygninger to steder med Wicked
    # Strong Fetish - Bladespire Hold (NV) og Bloodmaul Outpost (syd).
    10544: ("o", [
        ("Bladespire Hold building", 1949, 42.4, 52.6),
        ("Bloodmaul Outpost building", 1949, 45.1, 77.0),
    ]),
}


def season_of(title):
    """Event-nøgle for en sæson-quest, ellers None."""
    if title in SEASON_EXACT:
        return SEASON_EXACT[title]
    for frag, ev in SEASON_CONTAINS:
        if frag in title:
            return ev
    return None


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
    """Returnér (centroid, otype, pts, onames, omap). otype: 'u'=dræb enhed
    (sværd), 'o'=interager/brug item (tandhjul), 'i'=saml genstand (tandhjul).
    pts = alle Outland-spawnpunkter for målet (til område-markering).
    onames = navne på tællende enheder (rene dræb-mål).
    omap = {mob-navn: item-navn} for saml-fra-mob-quests, så mob-tooltips kan
    matche mobben mod DEN RIGTIGE objektiv-linje ('<item>: x/y') i live-loggen.
    Det undgår fejl som 'Warmaul Brute' vist under Gurok-questen, når pfQuest
    slår flere items sammen på samme quest.

    Vigtigt: et objektiv med et påkrævet/udleveret item (IR) eller et objekt
    (O) er en INTERACT/brug-quest (tandhjul) - selv hvis der også er enheder
    (fx 'brug banner ved Boulderfist-lejre'). Kun rene enheds-mål = dræb."""
    q = qdb.qdata[qid]
    if T(q) != "table" or not q["obj"]:
        return None, None, None, None, None
    obj = q["obj"]

    # Brug-item (IR) eller interager-med-objekt (O) => tandhjul.
    if obj["IR"] or obj["O"]:
        pts = _opts(obj["O"]) if obj["O"] else []
        if not pts and obj["U"]:
            pts = _upts(obj["U"])          # fald tilbage på enheder for placering
        if pts:
            return qdb.centroid(pts), "o", pts, None, None

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
            return qdb.centroid(pts), "u", pts, sorted(names), None

    if obj["I"]:
        upts, opts_, unames, omap = [], [], set(), {}
        for iid in obj["I"].values():
            iid = int(iid)
            iname = qdb.item_name(iid)
            it = qdb.idata[iid]
            if it is not None and T(it) == "table":
                if it["O"]:
                    for oid in it["O"].keys():
                        opts_ += [p for p in qdb.spawns(qdb.odata, int(oid)) if p[0] in OUTLAND]
                if it["U"]:
                    for uid in it["U"].keys():
                        uid = int(uid)
                        sp = [p for p in qdb.spawns(qdb.udata, uid) if p[0] in OUTLAND]
                        if sp:
                            upts += sp
                            mob = qdb.loc_name(qdb.uloc, qdb.uloc_v, uid)
                            unames.add(mob)
                            # Bind mobben til det item den dropper (til tooltips).
                            if iname:
                                omap[mob] = iname
        # Genstand fra et OBJEKT (fx kister/knuder) = loot/interager (tandhjul).
        # Kun fra ENHEDER = reelt et dræb (sværd, vis kilde-mobs). Ellers indsamling.
        if opts_:
            return qdb.centroid(opts_), "o", opts_, None, None
        if upts:
            return (qdb.centroid(upts), "u", upts,
                    sorted(unames) if unames else None, omap or None)
    return None, None, None, None, None


def outland_patrol(qid):
    """Ordnet 'patrulje'-/søge-rute for objektiver der er ÉN enkelt NPC-type
    spredt over en rute/et lille område (patruljerende eller få spredte spawns).
    Returnér (map, [(x,y), ...]) nærmeste-nabo-ordnet, så kortet kan tegne en
    streg 'her kan NPC'en findes'. None for enlige spawns og zone-brede
    bestande (fx clefthoofs), hvor en streg ikke giver mening."""
    q = qdb.qdata[qid]
    if T(q) != "table" or not q["obj"] or not q["obj"]["U"]:
        return None
    uids = [int(v) for v in q["obj"]["U"].values()]
    if len(uids) != 1:                       # kun ét enkelt (unikt) mål
        return None
    sp = [p for p in qdb.spawns(qdb.udata, uids[0]) if p[0] in OUTLAND]
    seen, g = set(), []
    for m, x, y in sp:                       # grid-dedup (samme som kortets sky)
        k = (round(x / 1.5), round(y / 1.5))
        if k in seen:
            continue
        seen.add(k)
        g.append((m, x, y))
    if not (2 <= len(g) <= 12):              # rute, ikke enlig spawn el. bestand
        return None
    mp = g[0][0]
    pts = [(x, y) for m, x, y in g if m == mp]
    xs = [x for x, y in pts]
    ys = [y for x, y in pts]
    span = ((max(xs) - min(xs)) ** 2 + (max(ys) - min(ys)) ** 2) ** 0.5
    if not (5 <= span <= 40):
        return None
    order = [pts.pop(0)]                      # nærmeste-nabo -> pæn rute
    while pts:
        lx, ly = order[-1]
        j = min(range(len(pts)),
                key=lambda i: (pts[i][0] - lx) ** 2 + (pts[i][1] - ly) ** 2)
        order.append(pts.pop(j))
    return mp, [(round(x, 1), round(y, 1)) for x, y in order]


def outland_split_points(qid):
    """Per-mål-punkter for quests med FLERE mål på hvert sit sted: enten flere
    saml-items (fx 'Thunderlord Clan Artifacts': tromme/pil/tavle) ELLER flere
    navngivne dræb-mål langt fra hinanden (fx Grimnok + Korgaah). Returnér
    [(navn, map, x, y), ...] så kortet kan vise én markør pr. mål og fjerne dem
    én ad gangen. None hvis ikke relevant (ét mål, ukendt navn, eller alle mål
    ligger samme sted)."""
    q = qdb.qdata[qid]
    if T(q) != "table" or not q["obj"]:
        return None
    obj = q["obj"]
    per = []
    if obj["I"]:
        # Saml FLERE items fra hvert sit sted (fx tromme/pil/tavle).
        for iid in obj["I"].values():
            iid = int(iid)
            iname = qdb.item_name(iid)
            if not iname:
                return None                  # uden navn kan vi ikke matche loggen
            it = qdb.idata[iid]
            pts = []
            if it is not None and T(it) == "table":
                if it["O"]:
                    for oid in it["O"].keys():
                        pts += [p for p in qdb.spawns(qdb.odata, int(oid)) if p[0] in OUTLAND]
                if it["U"]:
                    for uid in it["U"].keys():
                        pts += [p for p in qdb.spawns(qdb.udata, int(uid)) if p[0] in OUTLAND]
            c = qdb.centroid(pts) if pts else None
            if not c:
                return None                  # ufuldstændige data -> drop hele op
            per.append((iname, c))
        min_span2 = 9                        # items: >~3% spredning
    elif obj["U"]:
        # Dræb FLERE navngivne mål på hvert sit sted (fx Grimnok + Korgaah) -
        # kun når det er få mål der ligger LANGT fra hinanden (ellers ville en
        # kategori-flok, fx Kil'sorrow-orcs samme sted, blive splittet unødigt).
        uids = [int(v) for v in obj["U"].values()]
        if not (2 <= len(uids) <= 4):
            return None
        for uid in uids:
            sp = [p for p in qdb.spawns(qdb.udata, uid) if p[0] in OUTLAND]
            # Kun UNIKKE mål (få spawns) - ikke kategori-bestande (fx Umbrafen-
            # ogrer), som hellere skal vises som ét område/sky.
            if not sp or len(sp) > 6:
                return None
            per.append((qdb.loc_name(qdb.uloc, qdb.uloc_v, uid), qdb.centroid(sp)))
        min_span2 = 100                      # units: >~10% spredning
    else:
        return None
    if len(per) < 2:
        return None
    xs = [c[1] for _, c in per]
    ys = [c[2] for _, c in per]
    if (max(xs) - min(xs)) ** 2 + (max(ys) - min(ys)) ** 2 < min_span2:
        return None                          # reelt ét sted -> ingen split
    return [(n, c[0], round(c[1], 1), round(c[2], 1)) for n, c in per]


def build_area(pts, mapid, cap=24):
    """Nedsampl spawnpunkter (på målets kort) til en lille sky, der viser
    området. Grid-dedup så vi ikke gemmer hundredvis af punkter."""
    if not pts:
        return None
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
        obj, otype, opts, onames, omap = outland_objective(qid)
        if obj is None and qid in OBJ_OVERRIDE:      # manuelt sted (pfQuest mangler)
            m, ox, oy, ot = OBJ_OVERRIDE[qid]
            obj, otype = (m, ox, oy), ot
        op_manual = None
        if qid in OP_OVERRIDE:                        # manuelle per-sted-markører
            ot_ov, pts_ov = OP_OVERRIDE[qid]
            op_manual = [(n, m, x, y) for n, m, x, y in pts_ov]
            otype = ot_ov
            if obj is None:                          # sæt centroid som pil-mål
                mx = round(sum(p[2] for p in pts_ov) / len(pts_ov), 1)
                my = round(sum(p[3] for p in pts_ov) / len(pts_ov), 1)
                obj = (pts_ov[0][1], mx, my)
        # medtag kun quests med mindst én Outland-koordinat
        if not (giver or turnin or obj):
            continue
        title = qdb.title(qid)
        if not title or title.startswith("BETA "):   # BETA = test-quests, ikke live
            continue
        season = season_of(title)
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
            # ou = navne på enheder der tæller (til mob-tooltips OG til at vise
            # "Dræb: X" på kort-ikonet). Gemmes altid for rene dræb-mål.
            if onames:
                parts.append("ou={%s}" % ",".join('"%s"' % esc(n) for n in onames))
            # om = {mob-navn = item-navn}: binder hver kilde-mob til DET item den
            # dropper, så mob-tooltips kun matcher den korrekte objektiv-linje.
            if omap:
                pairs = ",".join('["%s"]="%s"' % (esc(m), esc(i))
                                 for m, i in sorted(omap.items()))
                parts.append("om={%s}" % pairs)
        # oi = item-id'er man skal samle (til quest-info i item-tooltips)
        objx = q["obj"]
        if T(objx) == "table" and objx["I"]:
            iids = sorted({int(i) for i in objx["I"].values()})
            if iids:
                parts.append("oi={%s}" % ",".join(str(i) for i in iids))
        if q["min"]:
            parts.append("lvl=%d" % int(q["min"]))
        if race:
            parts.append("race=%d" % race)
        if pre:
            parts.append("pre={%s}" % ",".join(str(p) for p in pre))
        # cl = "close"-gruppe (WoW ExclusiveGroup): gensidigt udelukkende quests
        # / breadcrumbs. Har du fuldført ÉN af dem, tilbydes de andre ikke mere,
        # så vi kan skjule det falske "!" (fx Old Oroks Area 52-breadcrumb).
        close = q["close"] if "close" in q.keys() else None
        if close and T(close) == "table":
            sibs = sorted({int(v) for v in close.values()} - {qid})
            if sibs:
                parts.append("cl={%s}" % ",".join(str(s) for s in sibs))
        if season:
            parts.append('ev="%s"' % season)
        # op = per-item saml-markører (flere items fra hvert sit sted).
        op = outland_split_points(qid) or op_manual
        if op:
            parts.append("op={%s}" % ",".join(
                '{"%s",%d,%.1f,%.1f}' % (esc(n), m, x, y) for n, m, x, y in op))
        # opat = søge-/patrulje-rute (streg på kort) for ét spredt NPC-mål.
        pat = outland_patrol(qid)
        if pat:
            parts.append("opat={%s}" % ",".join(
                "{%.1f,%.1f}" % (x, y) for x, y in pat[1]))
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
