local _, ns = ...

-- =========================================================================
-- Nagrand (Horde) - level 64-67
--
-- Rækkefølgen følger Wowheads leveling-guide for Burning Crusade Classic.
-- Quest-id'er og koordinater er verificeret mod pfQuest-databasen
-- (https://github.com/shagu/pfQuest, MIT-licens, © Eric Mauser/Shagu).
-- Ruten er GENERERET af tools/plans.py - rediger ikke i hånden.
--
-- Format: grupperede steps med elementer (kind = accept|do|turnin|travel|
-- fly|hearth|train|vendor|buy|note|ding|grind). Koordinater er zone-
-- procenter (x, y) på uiMapID:
--   1951 = Nagrand, 1949 = Blade's Edge Mountains
-- =========================================================================

ns.Q:RegisterRoute({
    key = "nagrand-horde",
    title = "Nagrand (Horde)",
    faction = "Horde",
    levels = "64-67",
    zones = { 1951 },
    next = "blades-edge-horde",
    steps = {
        { label = "Garadar", elements = {
                { kind = "travel", coords = { map = 1951, x = 55.4, y = 37.6 }, radius = 60,
                  text = "Garadar", note = "Følg vejen fra Terokkar ind i Nagrand til Mag'har-byen Garadar (flight point)." },
        }},
        { label = "Garadar", elements = {
                { kind = "accept", quest = 9863, title = "Vile Idolatry",
                  coords = { map = 1951, x = 54.8, y = 39.4 }, note = "Fra Farseer Kurkush." },
                { kind = "accept", quest = 9910, title = "Standards and Practices",
                  coords = { map = 1951, x = 55.6, y = 37.5 }, note = "Fra Elkay'gan the Mystic." },
                { kind = "accept", quest = 9935, title = "Wanted: Giselda the Crone",
                  coords = { map = 1951, x = 55.8, y = 38.0 }, note = "Dusør fra Garadar Bulletin Board." },
                { kind = "accept", quest = 9939, title = "Wanted: Zorbo the Advisor",
                  coords = { map = 1951, x = 55.8, y = 38.0 }, note = "Fra Garadar Bulletin Board." },
        }},
        { label = "Garadar", elements = {
                { kind = "do", quest = 9863, title = "Vile Idolatry",
                  coords = { map = 1951, x = 33.0, y = 41.0 }, note = "Dræb Murkblood-Broken ved Sunspring Post (vest) og Laughing Skull." },
        }},
        { label = "Garadar", elements = {
                { kind = "do", quest = 9910, title = "Standards and Practices",
                  coords = { map = 1951, x = 56.0, y = 73.0 }, note = "Dræb Kil'sorrow-orcs ved deres fæstning (sydøst)." },
        }},
        { label = "Garadar", elements = {
                { kind = "do", quest = 9935, title = "Wanted: Giselda the Crone",
                  coords = { map = 1951, x = 71.0, y = 82.0 }, note = "Dræb Giselda the Crone ved Kil'sorrow Fortress (sydøst)." },
        }},
        { label = "Garadar", elements = {
                { kind = "do", quest = 9939, title = "Wanted: Zorbo the Advisor",
                  coords = { map = 1951, x = 46.0, y = 22.0 }, note = "Dræb Zorbo the Advisor ved Warmaul Hill (nord)." },
        }},
        { label = "Garadar", elements = {
                { kind = "turnin", quest = 9863, title = "Vile Idolatry",
                  coords = { map = 1951, x = 54.8, y = 39.4 }, note = "Aflever hos Farseer Kurkush." },
                { kind = "turnin", quest = 9910, title = "Standards and Practices",
                  coords = { map = 1951, x = 55.6, y = 37.5 }, note = "Aflever hos Elkay'gan the Mystic." },
                { kind = "turnin", quest = 9935, title = "Wanted: Giselda the Crone",
                  coords = { map = 1951, x = 55.8, y = 37.9 }, note = "Aflever hos Warden Bullrok." },
                { kind = "turnin", quest = 9939, title = "Wanted: Zorbo the Advisor",
                  coords = { map = 1951, x = 55.8, y = 37.9 }, note = "Aflever hos Warden Bullrok." },
        }},
        { label = "Throne of the Elements", elements = {
                { kind = "accept", quest = 9870, title = "The Throne of the Elements",
                  coords = { map = 1951, x = 55.4, y = 38.0 }, note = "Fra Elementalist Yal'hah i Garadar." },
        }},
        { label = "Throne of the Elements", elements = {
                { kind = "travel", coords = { map = 1951, x = 60.7, y = 22.1 }, radius = 60,
                  text = "Throne of the Elements", note = "Nordøst for Garadar: elementernes helligdom." },
        }},
        { label = "Throne of the Elements", elements = {
                { kind = "turnin", quest = 9870, title = "The Throne of the Elements",
                  coords = { map = 1951, x = 60.7, y = 22.1 }, note = "Aflever hos Elementalist Sharvak." },
                { kind = "accept", quest = 9800, title = "A Rare Bean",
                  coords = { map = 1951, x = 60.8, y = 22.4 }, note = "Fra Elementalist Lo'ap." },
                { kind = "accept", quest = 9818, title = "The Underneath",
                  coords = { map = 1951, x = 60.7, y = 22.7 }, note = "Fra Elementalist Untrag." },
        }},
        { label = "Throne of the Elements", elements = {
                { kind = "do", quest = 9800, title = "A Rare Bean",
                  coords = { map = 1951, x = 58.0, y = 30.0 }, note = "Saml Bak'nari Coffee Beans på markerne." },
        }},
        { label = "Throne of the Elements", elements = {
                { kind = "do", quest = 9818, title = "The Underneath",
                  coords = { map = 1951, x = 61.0, y = 24.0 }, note = "Undersøg The Underneath under thronet." },
                { kind = "turnin", quest = 9800, title = "A Rare Bean",
                  coords = { map = 1951, x = 60.8, y = 22.4 }, note = "Aflever hos Elementalist Lo'ap." },
                { kind = "turnin", quest = 9818, title = "The Underneath",
                  coords = { map = 1951, x = 61.3, y = 24.8 }, note = "Aflever hos Gordawg." },
        }},
        { label = "Nesingwary Safari", elements = {
                { kind = "accept", quest = 10114, title = "The Nesingwary Safari",
                  coords = { map = 1951, x = 55.4, y = 37.3 }, note = "Fra Ohlorn Farstrider i Garadar." },
        }},
        { label = "Nesingwary Safari", elements = {
                { kind = "travel", coords = { map = 1951, x = 71.5, y = 40.8 }, radius = 60,
                  text = "Nesingwary Safari", note = "Hemet Nesingwarys jagtlejr i øst." },
        }},
        { label = "Nesingwary Safari", elements = {
                { kind = "turnin", quest = 10114, title = "The Nesingwary Safari",
                  coords = { map = 1951, x = 71.6, y = 40.5 }, note = "Aflever hos Shado 'Fitz' Farstrider." },
                { kind = "accept", quest = 9789, title = "Clefthoof Mastery",
                  coords = { map = 1951, x = 71.5, y = 40.8 }, note = "Clefthoof Mastery - fra Hemet Nesingwary." },
                { kind = "accept", quest = 9854, title = "Windroc Mastery",
                  coords = { map = 1951, x = 71.6, y = 40.5 }, note = "Windroc Mastery - fra Shado Farstrider." },
                { kind = "accept", quest = 9857, title = "Talbuk Mastery",
                  coords = { map = 1951, x = 71.4, y = 40.6 }, note = "Talbuk Mastery - fra Harold Lane." },
        }},
        { label = "Nesingwary Safari", elements = {
                { kind = "do", quest = 9789, title = "Clefthoof Mastery",
                  coords = { map = 1951, x = 63.0, y = 50.0 }, note = "Jag clefthoofs på sletterne (findes i hele Nagrand)." },
        }},
        { label = "Nesingwary Safari", elements = {
                { kind = "do", quest = 9854, title = "Windroc Mastery",
                  coords = { map = 1951, x = 66.0, y = 45.0 }, note = "Jag windrocs på sletterne." },
        }},
        { label = "Nesingwary Safari", elements = {
                { kind = "do", quest = 9857, title = "Talbuk Mastery",
                  coords = { map = 1951, x = 60.0, y = 48.0 }, note = "Jag talbuks på sletterne." },
        }},
        { label = "Nesingwary Safari", elements = {
                { kind = "turnin", quest = 9789, title = "Clefthoof Mastery",
                  coords = { map = 1951, x = 71.5, y = 40.8 }, note = "Aflever hos Hemet Nesingwary." },
                { kind = "turnin", quest = 9854, title = "Windroc Mastery",
                  coords = { map = 1951, x = 71.6, y = 40.5 }, note = "Aflever hos Shado 'Fitz' Farstrider." },
                { kind = "turnin", quest = 9857, title = "Talbuk Mastery",
                  coords = { map = 1951, x = 71.4, y = 40.6 }, note = "Aflever hos Harold Lane." },
        }},
        { label = "Nesingwary Safari", elements = {
                { kind = "note", coords = { map = 1951, x = 71.5, y = 40.8 }, text = "Mastery-kæderne fortsætter",
                  note = "Hver Mastery har tre trin (Clefthoof 9789->9850->9851, Windroc 9854->9855->9856, Talbuk 9857->9858->9859) og munder ud i 'The Ultimate Bloodsport'. Enorm XP - fortsæt sideløbende. Tryk 'Spring over', når du er klar." },
        }},
        { label = "Consortium: Aeris Landing", elements = {
                { kind = "travel", coords = { map = 1951, x = 31.4, y = 57.8 }, radius = 60,
                  text = "Aeris Landing", note = "Consortium-lejren ved foden af Oshu'gun i sydvest." },
        }},
        { label = "Consortium: Aeris Landing", elements = {
                { kind = "accept", quest = 9882, title = "Stealing from Thieves",
                  coords = { map = 1951, x = 31.4, y = 57.8 }, note = "Fra Gezhe." },
                { kind = "accept", quest = 9914, title = "A Head Full of Ivory",
                  coords = { map = 1951, x = 31.8, y = 56.8 }, note = "Fra Shadrek." },
        }},
        { label = "Consortium: Aeris Landing", elements = {
                { kind = "do", quest = 9882, title = "Stealing from Thieves",
                  coords = { map = 1951, x = 35.0, y = 55.0 }, note = "Saml Obsidian Warbeads/krystaller fra ogrer på Spirit Fields." },
        }},
        { label = "Consortium: Aeris Landing", elements = {
                { kind = "do", quest = 9914, title = "A Head Full of Ivory",
                  coords = { map = 1951, x = 40.0, y = 55.0 }, note = "Saml elfenben fra clefthoofs." },
        }},
        { label = "Consortium: Aeris Landing", elements = {
                { kind = "turnin", quest = 9882, title = "Stealing from Thieves",
                  coords = { map = 1951, x = 31.4, y = 57.8 }, note = "Aflever hos Gezhe." },
                { kind = "turnin", quest = 9914, title = "A Head Full of Ivory",
                  coords = { map = 1951, x = 31.8, y = 56.8 }, note = "Aflever hos Shadrek." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "note", coords = { map = 1951, x = 71.5, y = 40.8 }, text = "Gør Nesingwary-kæderne færdige",
                  note = "Du er allerede ved safarien - Mastery-kædernes tier 2 og 3 giver enorm XP for dyr du alligevel render forbi. Meget effektivt op til level 66-67." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "accept", quest = 9850, title = "Clefthoof Mastery",
                  coords = { map = 1951, x = 71.5, y = 40.8 }, note = "Clefthoof Mastery tier 2 - fra Hemet Nesingwary." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "do", quest = 9850, title = "Clefthoof Mastery",
                  coords = { map = 1951, x = 51.3, y = 46.2 }, note = "Jag flere clefthoofs på sletterne." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "turnin", quest = 9850, title = "Clefthoof Mastery",
                  coords = { map = 1951, x = 71.5, y = 40.8 }, note = "Aflever hos Hemet Nesingwary." },
                { kind = "accept", quest = 9851, title = "Clefthoof Mastery",
                  coords = { map = 1951, x = 71.5, y = 40.8 }, note = "Clefthoof Mastery tier 3 - fra Hemet Nesingwary." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "do", quest = 9851, title = "Clefthoof Mastery",
                  coords = { map = 1951, x = 41.4, y = 61.6 }, note = "Jag de største clefthoofs." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "turnin", quest = 9851, title = "Clefthoof Mastery",
                  coords = { map = 1951, x = 71.5, y = 40.8 }, note = "Aflever hos Hemet Nesingwary." },
                { kind = "accept", quest = 9855, title = "Windroc Mastery",
                  coords = { map = 1951, x = 71.6, y = 40.5 }, note = "Windroc Mastery tier 2 - fra Shado 'Fitz' Farstrider." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "do", quest = 9855, title = "Windroc Mastery",
                  coords = { map = 1951, x = 48.5, y = 60.4 }, note = "Jag flere windrocs." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "turnin", quest = 9855, title = "Windroc Mastery",
                  coords = { map = 1951, x = 71.6, y = 40.5 }, note = "Aflever hos Shado 'Fitz' Farstrider." },
                { kind = "accept", quest = 9856, title = "Windroc Mastery",
                  coords = { map = 1951, x = 71.6, y = 40.5 }, note = "Windroc Mastery tier 3 - fra Shado." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "do", quest = 9856, title = "Windroc Mastery",
                  coords = { map = 1951, x = 31.0, y = 31.0 }, note = "Jag de største windrocs." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "turnin", quest = 9856, title = "Windroc Mastery",
                  coords = { map = 1951, x = 71.6, y = 40.5 }, note = "Aflever hos Shado 'Fitz' Farstrider." },
                { kind = "accept", quest = 9858, title = "Talbuk Mastery",
                  coords = { map = 1951, x = 71.4, y = 40.6 }, note = "Talbuk Mastery tier 2 - fra Harold Lane." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "do", quest = 9858, title = "Talbuk Mastery",
                  coords = { map = 1951, x = 49.8, y = 40.3 }, note = "Jag flere talbuks." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "turnin", quest = 9858, title = "Talbuk Mastery",
                  coords = { map = 1951, x = 71.4, y = 40.6 }, note = "Aflever hos Harold Lane." },
                { kind = "accept", quest = 9859, title = "Talbuk Mastery",
                  coords = { map = 1951, x = 71.4, y = 40.6 }, note = "Talbuk Mastery tier 3 - fra Harold Lane." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "do", quest = 9859, title = "Talbuk Mastery",
                  coords = { map = 1951, x = 26.1, y = 53.1 }, note = "Jag de største talbuks." },
        }},
        { label = "Ekstra: Mastery-opfølgere (valgfri - stor XP)", elements = {
                { kind = "turnin", quest = 9859, title = "Talbuk Mastery",
                  coords = { map = 1951, x = 71.4, y = 40.6 }, note = "Aflever hos Harold Lane." },
        }},
        { label = "Ekstra: Lantresor of the Blade (valgfri)", elements = {
                { kind = "accept", quest = 9927, title = "Ruthless Cunning",
                  coords = { map = 1951, x = 73.8, y = 62.6 }, note = "Fra Lantresor of the Blade ved Burning Blade Ruins (sydøst)." },
        }},
        { label = "Ekstra: Lantresor of the Blade (valgfri)", elements = {
                { kind = "do", quest = 9927, title = "Ruthless Cunning",
                  coords = { map = 1951, x = 70.7, y = 79.0 }, note = "Fuldfør Lantresors opgave." },
        }},
        { label = "Ekstra: Lantresor of the Blade (valgfri)", elements = {
                { kind = "turnin", quest = 9927, title = "Ruthless Cunning",
                  coords = { map = 1951, x = 73.8, y = 62.6 }, note = "Aflever hos Lantresor of the Blade." },
                { kind = "accept", quest = 9931, title = "Returning the Favor",
                  coords = { map = 1951, x = 73.8, y = 62.6 }, note = "Fra Lantresor." },
        }},
        { label = "Ekstra: Lantresor of the Blade (valgfri)", elements = {
                { kind = "do", quest = 9931, title = "Returning the Favor",
                  coords = { map = 1951, x = 45.8, y = 22.4 }, note = "Gengæld tjenesten." },
        }},
        { label = "Ekstra: Lantresor of the Blade (valgfri)", elements = {
                { kind = "turnin", quest = 9931, title = "Returning the Favor",
                  coords = { map = 1951, x = 73.8, y = 62.6 }, note = "Aflever hos Lantresor of the Blade." },
                { kind = "accept", quest = 9932, title = "Body of Evidence",
                  coords = { map = 1951, x = 73.8, y = 62.6 }, note = "Fra Lantresor." },
        }},
        { label = "Ekstra: Lantresor of the Blade (valgfri)", elements = {
                { kind = "do", quest = 9932, title = "Body of Evidence",
                  coords = { map = 1951, x = 46.6, y = 24.4 }, note = "Skaf beviserne." },
        }},
        { label = "Ekstra: Lantresor of the Blade (valgfri)", elements = {
                { kind = "turnin", quest = 9932, title = "Body of Evidence",
                  coords = { map = 1951, x = 73.8, y = 62.6 }, note = "Aflever hos Lantresor of the Blade." },
                { kind = "accept", quest = 9934, title = "Message to Garadar",
                  coords = { map = 1951, x = 73.8, y = 62.6 }, note = "Fra Lantresor." },
        }},
        { label = "Ekstra: Lantresor of the Blade (valgfri)", elements = {
                { kind = "turnin", quest = 9934, title = "Message to Garadar",
                  coords = { map = 1951, x = 55.4, y = 37.6 }, note = "Bring beskeden til Garrosh i Garadar." },
        }},
        { label = "Valgfri lore & gruppe-indhold", elements = {
                { kind = "note", coords = { map = 1951, x = 55.4, y = 37.6 }, text = "Garrosh & Greatmother Geyah",
                  note = "Valgfrit: lore-kæden fra Garrosh fører til 'A Visit With the Greatmother' og Thralls ankomst. Følg den for XP + historie." },
        }},
        { label = "Valgfri lore & gruppe-indhold", elements = {
                { kind = "note", coords = { map = 1951, x = 42.8, y = 20.7 }, text = "Ring of Blood (gruppe)",
                  note = "Valgfrit: seks gladiator-kampe for en 5-mands gruppe ved Gurgthock - en af TBC's bedste XP-klumper plus et stærkt våben. Find en gruppe!" },
        }},
        { label = "Videre", elements = {
                { kind = "ding", level = 67, note = "Du skal være level 67. Mangler du XP: gør Mastery-opfølgerne eller Lantresor-kæden færdige, eller grind clefthoofs/talbuks på sletterne indtil du dinger." },
        }},
        { label = "Videre", elements = {
                { kind = "travel", coords = { map = 1949, x = 51.9, y = 58.4 }, radius = 100,
                  text = "Mod Blade's Edge Mountains", note = "Flyv nordpå gennem bjergene til Thunderlord Stronghold i Blade's Edge Mountains. Qeasy skifter automatisk rute." },
        }},
    },
})
