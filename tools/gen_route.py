#!/usr/bin/env python3
"""Generator: bygger Qeasy Routes/*.lua (grupperet v2-format) fra planer.

En rute = liste af STEPS (grupper). Hvert step har en label og en liste af
ELEMENTS. Koordinater/titler slås op i pfQuest (MIT, © Shagu):
ACCEPT -> quest-giver, TURNIN -> modtager, DO -> objective-centroid.
"""
import qdb

HORDE_MASK = 2 + 16 + 32 + 128 + 512


def esc(s):
    return str(s).replace("\\", "\\\\").replace('"', '\\"')


# Elementer der altid udgør deres eget lille step (distinkte handlinger).
HARD_KINDS = {"travel", "fly", "hearth", "train", "vendor", "buy",
              "repair", "deliver", "note", "ding", "grind"}
# Sammenlæg kun quest-handlinger inden for denne afstand (zone-%) på samme kort.
MERGE_DIST = 3.5


class Plan:
    def __init__(self, key, title, levels, zones, main_map, nxt=None):
        self.meta = dict(key=key, title=title, levels=levels, zones=zones, nxt=nxt)
        self.main_map = main_map
        self.flat = []           # liste af (chapter, element)
        self.chapter = ""
        self.warnings = []

    # -- kapitler (S/step sætter kun overskriften; steps dannes ved build) --
    def step(self, label=""):
        self.chapter = label
        return self

    S = step

    def _add(self, el):
        self.flat.append((self.chapter, el))

    # -- opdel flad liste i mange små steps (RestedXP-stil) ----------
    def _split(self):
        steps = []
        cur, anchor = None, None
        for chapter, el in self.flat:
            if el["kind"] in HARD_KINDS:
                steps.append({"label": chapter, "elements": [el]})
                cur, anchor = None, None
                continue
            c = el.get("coords")
            merge = (cur is not None and cur["label"] == chapter and anchor and c
                     and anchor[0] == c[0]
                     and ((anchor[1] - c[1]) ** 2 + (anchor[2] - c[2]) ** 2) ** 0.5 <= MERGE_DIST)
            if merge:
                cur["elements"].append(el)
            else:
                cur = {"label": chapter, "elements": [el]}
                anchor = c
                steps.append(cur)
        return steps

    # -- rejse / logistik -------------------------------------------
    def T(self, label, coords, note, radius=60):
        self._add({"kind": "travel", "coords": coords, "radius": radius,
                   "text": label, "note": note})

    def fly(self, label, coords, note, radius=60):
        self._add({"kind": "fly", "coords": coords, "radius": radius,
                   "text": label, "note": note})

    def hearth(self, label, coords, note=None):
        self._add({"kind": "hearth", "coords": coords, "text": label, "note": note})

    def train(self, coords, text="Træn dine spells hos klassetræneren", note=None):
        self._add({"kind": "train", "coords": coords, "text": text, "note": note})

    def vendor(self, coords, text="Sælg/reparér hos vendoren", note=None):
        self._add({"kind": "vendor", "coords": coords, "text": text, "note": note})

    def buy(self, coords, text, note=None):
        self._add({"kind": "buy", "coords": coords, "text": text, "note": note})

    def N(self, label, coords, note, optional=False):
        self._add({"kind": "note", "coords": coords, "text": label,
                   "note": note, "optional": optional})

    def ding(self, level):
        self._add({"kind": "ding", "level": level})

    def grind(self, level, text=None):
        self._add({"kind": "grind", "level": level, "text": text})

    # -- quest-elementer --------------------------------------------
    def A(self, qid, note=None, optional=False):
        self._quest("accept", qid, note, optional)

    def D(self, qid, note, at=None, optional=False):
        self._quest("do", qid, note, optional, at=at)

    def X(self, qid, note=None, optional=False):
        self._quest("turnin", qid, note, optional)

    def _info(self, qid):
        i = qdb.info(qid, prefer_map=self.main_map)
        if not i or not i["title"]:
            raise SystemExit(f"{self.meta['key']}: quest {qid} findes ikke")
        if i["race"] and not (i["race"] & HORDE_MASK):
            raise SystemExit(f"{self.meta['key']}: quest {qid} '{i['title']}' er Alliance-only!")
        return i

    def _quest(self, kind, qid, note, optional, at=None):
        i = self._info(qid)
        coords = None
        if kind == "accept":
            coords = i["start"][1] if i["start"] else None
            if note is None and i["start"]:
                note = f"Fra {i['start'][0]}."
        elif kind == "turnin":
            coords = i["end"][1] if i["end"] else None
            if note is None and i["end"]:
                note = f"Aflever hos {i['end'][0]}."
        else:  # do
            coords = at or i["obj"] or (i["end"][1] if i["end"] else None)
            if at is None and i["obj"] is None:
                self.warnings.append(f"DO {qid} '{i['title']}': ingen objective-koordinater")
        if coords is None:
            self.warnings.append(f"{kind} {qid} '{i['title']}': INGEN koordinater")
        self._add({"kind": kind, "quest": qid, "title": i["title"],
                   "coords": coords, "note": note, "optional": optional})

    # -- serialisering ----------------------------------------------
    def _emit_element(self, el):
        parts = [f'kind = "{el["kind"]}"']
        if el.get("quest"):
            parts.append(f'quest = {el["quest"]}')
        if el.get("title"):
            parts.append(f'title = "{esc(el["title"])}"')
        if el.get("coords"):
            m, x, y = el["coords"]
            parts.append(f"coords = {{ map = {m}, x = {x}, y = {y} }}")
        if el.get("radius"):
            parts.append(f'radius = {el["radius"]}')
        if el.get("level"):
            parts.append(f'level = {el["level"]}')
        if el.get("text"):
            parts.append(f'text = "{esc(el["text"])}"')
        if el.get("note"):
            parts.append(f'note = "{esc(el["note"])}"')
        # Notes er altid synlige (kræver manuel bekræftelse); andre kan være valgfri.
        if el.get("optional") and el["kind"] != "note":
            parts.append("optional = true")
        head = ", ".join(parts[:3])
        tail = ", ".join(parts[3:])
        if tail:
            return f"                {{ {head},\n                  {tail} }},"
        return f"                {{ {head} }},"

    def build(self, header_comment):
        m = self.meta
        out = ["local _, ns = ...", "", header_comment, "",
               "ns.Q:RegisterRoute({",
               f'    key = "{m["key"]}",',
               f'    title = "{esc(m["title"])}",',
               '    faction = "Horde",',
               f'    levels = "{m["levels"]}",',
               f'    zones = {{ {", ".join(str(z) for z in m["zones"])} }},']
        if m["nxt"]:
            out.append(f'    next = "{m["nxt"]}",')
        out.append("    steps = {")
        self._built = self._split()
        for step in self._built:
            if not step["elements"]:
                continue
            out.append(f'        {{ label = "{esc(step["label"])}", elements = {{')
            for el in step["elements"]:
                out.append(self._emit_element(el))
            out.append("        }},")
        out.append("    },")
        out.append("})")
        out.append("")
        return "\n".join(out)


HEADER = """-- =========================================================================
-- {title} - level {levels}
--
-- Rækkefølgen følger Wowheads leveling-guide for Burning Crusade Classic.
-- Quest-id'er og koordinater er verificeret mod pfQuest-databasen
-- (https://github.com/shagu/pfQuest, MIT-licens, © Eric Mauser/Shagu).
-- Ruten er GENERERET af tools/plans.py - rediger ikke i hånden.
--
-- Format: grupperede steps med elementer (kind = accept|do|turnin|travel|
-- fly|hearth|train|vendor|buy|note|ding|grind). Koordinater er zone-
-- procenter (x, y) på uiMapID:
--   {maps}
-- ========================================================================="""


def write(plan, path, maps_desc):
    src = plan.build(HEADER.format(title=plan.meta["title"],
                                   levels=plan.meta["levels"], maps=maps_desc))
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(src)
    n_steps = sum(1 for s in plan._built if s["elements"])
    n_el = sum(len(s["elements"]) for s in plan._built)
    print(f"{path.split('/')[-1]}: {n_steps} steps, {n_el} elementer")
    for w in plan.warnings:
        print(f"  ⚠ {w}")
