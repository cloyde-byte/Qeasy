#!/usr/bin/env python3
"""Generér Data/OutlandQuestFlags.lua: kurateret liste over PvP- og gentagelige
(repeatable) quests i Outland, så kort-ikonet kan farves (rødt/blåt '!').

pfQuest-TBC har ingen PvP/daily/repeatable-flag, og TBC-klienten har ingen
pålidelig statisk API til det - så dette er en kurateret liste (som Questie).
Quests angives ved NAVN og slås op til id via pfQuest, så id'erne er korrekte.
Kun quests der allerede findes i Data/OutlandQuests.lua medtages.
"""
import os
import re
import qdb

T = qdb.T

# Gentagelige rep-turn-ins i Outland (Horde/neutrale). Udvid frit.
REPEAT_NAMES = [
    "Coilfang Armaments",
    "Unidentified Plant Parts",
    "Dampscale Basilisk Eye",
    "Obsidian Warbeads",
    "Mark of Kil'jaeden",
    "Mark of Sargeras",
    "Fel Armaments",
    "Arcane Tomes",
    "Sunfury Signet",
    "Firewing Signet",
    "Oshu'gun Crystal Powder",
    "Oshu'gun Crystal Fragment",
]

# PvP-relaterede quests (Halaa m.fl.).
PVP_NAMES = [
    "More Warbeads!",
    "Gladiators of Halaa",
    "Banner Down!",
    "Bloody Coins? What Are Those?",
]


def db_ids(root):
    """Sæt af quest-id'er der allerede er i vores Outland-DB."""
    path = os.path.join(root, "Data", "OutlandQuests.lua")
    ids = set()
    for m in re.finditer(r'^\s*\[(\d+)\]=\{', open(path, encoding="utf-8").read(), re.M):
        ids.add(int(m.group(1)))
    return ids


def ids_for(name, valid):
    out = []
    for qid in valid:
        if qdb.title(qid) == name:
            out.append(qid)
    return out


def main():
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    valid = db_ids(root)
    flags = {}
    report = {"repeat": [], "pvp": []}
    # PvP vinder over repeatable hvis en quest står i begge.
    for name in REPEAT_NAMES:
        for qid in ids_for(name, valid):
            flags[qid] = "repeat"
            report["repeat"].append((qid, name))
    for name in PVP_NAMES:
        for qid in ids_for(name, valid):
            flags[qid] = "pvp"
            report["pvp"].append((qid, name))

    path = os.path.join(root, "Data", "OutlandQuestFlags.lua")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write("local _, ns = ...\n")
        fh.write("-- GENERERET af tools/gen_flags.py. Kurateret liste (pfQuest har "
                 "ingen flag-data).\n")
        fh.write("-- ns.QuestFlags[questID] = 'pvp' (rødt !) | 'repeat' (blåt !)\n")
        fh.write("ns.QuestFlags = {\n")
        for qid in sorted(flags):
            fh.write('  [%d]="%s",\n' % (qid, flags[qid]))
        fh.write("}\n")
    print(f"{path}: {len(flags)} quests markeret")
    for kind in ("pvp", "repeat"):
        print(f"  {kind}:")
        for qid, name in sorted(report[kind]):
            print(f"    {qid}  {name}")


if __name__ == "__main__":
    main()
