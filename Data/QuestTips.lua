local _, ns = ...

-- =========================================================================
-- Qeasy QuestTips: HÅNDSKREVNE tips til enkelte quests (i modsætning til den
-- genererede QuestDB). Vises i guide-vinduet for den/de quests du har i fokus.
-- Formålet er "lokal viden" som data ikke fanger: skjulte mekanikker, smarte
-- ruter, items man skal huske, osv.
--
--   ns.QuestTips[questID] = { "tip 1", "tip 2", ... }
--
-- Tilføj frit flere. Nøglen er quest-id'et (samme som i QuestDB).
-- =========================================================================

ns.QuestTips = {
    -- Nordøst-Nagrand: Ikeyens ejendele ligger inde i en hule.
    [9788] = {
        "Ikeyen's Belongings ligger i en HULE i det nordøstlige Nagrand, nær grænsen til Zangarmarsh (Umbrafen-området) - ikke ude i det fri.",
        "Følg pilen helt hen til hulen og gå indenfor for at samle ejendelene.",
    },

    -- Nesingwary-jagtquests: de tre 'Mastery'-kæder deler jagtmarker.
    [9789] = { "Clefthoof, Talbuk og Windroc Mastery deler samme jagtmarker - tag alle tre kæder samtidig og dræb på kryds og tværs." },
    [9857] = { "Clefthoof, Talbuk og Windroc Mastery deler samme jagtmarker - tag alle tre kæder samtidig og dræb på kryds og tværs." },
    [9854] = { "Clefthoof, Talbuk og Windroc Mastery deler samme jagtmarker - tag alle tre kæder samtidig og dræb på kryds og tværs." },

    -- Sydvest-Nagrand (Sunspring): saml de nærliggende quests i én tur.
    [9882] = { "Du er helt i sydvest - tag også 'Shattering the Veil' og andre Sunspring-quests med, mens du er hernede." },
}
