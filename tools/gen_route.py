#!/usr/bin/env python3
"""Generator: bygger Qeasy Routes/*.lua ud fra planer med quest-id'er.

Koordinater og titler slås op i pfQuest TBC-databasen (MIT, © Shagu):
ACCEPT -> quest-giver, TURNIN -> modtager, DO -> objective-centroid.
"""
import qdb

HORDE_MASK = 2 + 16 + 32 + 128 + 512


def esc(s):
    return s.replace("\\", "\\\\").replace('"', '\\"')


class Plan:
    def __init__(self, key, title, levels, zones, main_map, nxt=None):
        self.meta = dict(key=key, title=title, levels=levels, zones=zones, nxt=nxt)
        self.main_map = main_map
        self.rows = []
        self.warnings = []

    def S(self, text):
        self.rows.append(("SECTION", text))

    def T(self, label, coords, note, radius=60):
        self.rows.append(("TRAVEL", label, coords, note, radius))

    def N(self, label, coords, note, optional=False):
        self.rows.append(("NOTE", label, coords, note, optional))

    def A(self, qid, note=None, optional=False, label=None):
        self.rows.append(("ACCEPT", qid, note, optional, label))

    def D(self, qid, note, at=None, optional=False, label=None):
        self.rows.append(("DO", qid, note, optional, label, at))

    def X(self, qid, note=None, optional=False, label=None):
        self.rows.append(("TURNIN", qid, note, optional, label))

    def q(self, qid):
        i = qdb.info(qid, prefer_map=self.main_map)
        if not i or not i["title"]:
            raise SystemExit(f"{self.meta['key']}: quest {qid} findes ikke")
        if i["race"] and not (i["race"] & HORDE_MASK):
            raise SystemExit(f"{self.meta['key']}: quest {qid} '{i['title']}' er Alliance-only!")
        return i

    def emit_step(self, kind, qid, note, optional, label, at=None):
        i = self.q(qid)
        lines = [f'        {{ type = "{kind}", quest = {qid}, title = "{esc(i["title"])}",']
        coords = None
        if kind == "ACCEPT":
            coords = i["start"][1] if i["start"] else None
            if note is None and i["start"]:
                note = f"Fra {i['start'][0]}."
        elif kind == "TURNIN":
            coords = i["end"][1] if i["end"] else None
            if note is None and i["end"]:
                note = f"Aflever hos {i['end'][0]}."
        elif kind == "DO":
            coords = at or i["obj"] or (i["end"][1] if i["end"] else None)
            if at is None and i["obj"] is None:
                self.warnings.append(f"DO {qid} '{i['title']}': ingen objective-koordinater - bruger aflevering")
        if coords is None:
            self.warnings.append(f"{kind} {qid} '{i['title']}': INGEN koordinater")
        attrs = []
        if coords:
            attrs.append(f"coords = {{ map = {coords[0]}, x = {coords[1]}, y = {coords[2]} }}")
        if label:
            attrs.append(f'label = "{esc(label)}"')
        if optional:
            attrs.append("optional = true")
        if attrs:
            lines.append("          " + ", ".join(attrs) + ("," if note else " },"))
        if note:
            lines.append(f'          note = "{esc(note)}" }},')
        elif not attrs:
            lines[-1] = lines[-1].rstrip(",") + " },"
        return "\n".join(lines)

    def build(self, header_comment):
        out = ['local _, ns = ...', '', header_comment, '']
        m = self.meta
        out.append("ns.Q:RegisterRoute({")
        out.append(f'    key = "{m["key"]}",')
        out.append(f'    title = "{esc(m["title"])}",')
        out.append('    faction = "Horde",')
        out.append(f'    levels = "{m["levels"]}",')
        out.append(f'    zones = {{ {", ".join(str(z) for z in m["zones"])} }},')
        if m["nxt"]:
            out.append(f'    next = "{m["nxt"]}",')
        out.append("    steps = {")
        first = True
        for row in self.rows:
            kind = row[0]
            if kind == "SECTION":
                pad = max(2, (68 - len(row[1])) // 2)
                if not first:
                    out.append("")
                out.append(f'        -- {"=" * pad} {row[1]} {"=" * pad}')
            elif kind == "TRAVEL":
                _, label, coords, note, radius = row
                out.append(f'        {{ type = "TRAVEL", label = "{esc(label)}",')
                out.append(f'          coords = {{ map = {coords[0]}, x = {coords[1]}, y = {coords[2]} }}, radius = {radius},')
                out.append(f'          note = "{esc(note)}" }},')
            elif kind == "NOTE":
                _, label, coords, note, optional = row
                opt = ", optional = true" if optional else ""
                out.append(f'        {{ type = "NOTE", label = "{esc(label)}"{opt},')
                if coords:
                    out.append(f'          coords = {{ map = {coords[0]}, x = {coords[1]}, y = {coords[2]} }},')
                out.append(f'          note = "{esc(note)}" }},')
            elif kind == "DO":
                _, qid, note, optional, label, at = row
                out.append(self.emit_step("DO", qid, note, optional, label, at))
            else:
                _, qid, note, optional, label = row
                out.append(self.emit_step(kind, qid, note, optional, label))
            first = False
        out.append("    },")
        out.append("})")
        out.append("")
        return "\n".join(out)


HEADER = """-- =========================================================================
-- {title} - level {levels}
--
-- Rækkefølgen følger Wowheads leveling-guide for Burning Crusade Classic.
-- Quest-id'er og koordinater er verificeret mod pfQuest-databasen
-- (https://github.com/shagu/pfQuest, MIT-licens, © Eric Mauser/Shagu):
-- ACCEPT peger på quest-giveren, TURNIN på modtageren og DO på midten af
-- objective-området.
--
-- Koordinater er zone-procenter (x, y) på uiMapID:
--   {maps}
-- ========================================================================="""


def write(plan, path, maps_desc):
    src = plan.build(HEADER.format(title=plan.meta["title"], levels=plan.meta["levels"], maps=maps_desc))
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(src)
    print(f"{path}: {sum(1 for r in plan.rows if r[0] != 'SECTION')} trin")
    for w in plan.warnings:
        print(f"  ⚠ {w}")
