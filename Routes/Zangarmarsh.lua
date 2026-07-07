local _, ns = ...

-- =========================================================================
-- Zangarmarsh (Horde) - level 61-64
--
-- Rækkefølgen følger Wowheads leveling-guide for Burning Crusade Classic.
-- Quest-id'er og koordinater er verificeret mod pfQuest-databasen
-- (https://github.com/shagu/pfQuest, MIT-licens, © Eric Mauser/Shagu).
-- Ruten er GENERERET af tools/plans.py - rediger ikke i hånden.
--
-- Format: grupperede steps med elementer (kind = accept|do|turnin|travel|
-- fly|hearth|train|vendor|buy|note|ding|grind). Koordinater er zone-
-- procenter (x, y) på uiMapID:
--   1946 = Zangarmarsh, 1952 = Terokkar Forest
-- =========================================================================

ns.Q:RegisterRoute({
    key = "zangarmarsh-horde",
    title = "Zangarmarsh (Horde)",
    faction = "Horde",
    levels = "61-64",
    zones = { 1946 },
    next = "terokkar-horde",
    steps = {
        { label = "Cenarion Refuge", elements = {
                { kind = "travel", coords = { map = 1946, x = 78.4, y = 62.0 }, radius = 60,
                  text = "Cenarion Refuge", note = "Følg vejen fra Hellfire ind i Zangarmarsh til Cenarion Refuge." },
        }},
        { label = "Cenarion Refuge", elements = {
                { kind = "accept", quest = 9802, title = "Plants of Zangarmarsh",
                  coords = { map = 1946, x = 80.3, y = 64.2 }, note = "Fra Lauranna Thar'well. Saml Unidentified Plant Parts fra planter/mobs i hele zonen undervejs." },
                { kind = "accept", quest = 9730, title = "Leader of the Darkcrest",
                  coords = { map = 1946, x = 79.1, y = 64.9 }, note = "Wanted-plakat ved refuge." },
                { kind = "accept", quest = 9817, title = "Leader of the Bloodscale",
                  coords = { map = 1946, x = 79.1, y = 64.9 }, note = "Fra Wanted Poster." },
                { kind = "accept", quest = 9716, title = "Disturbance at Umbrafen Lake",
                  coords = { map = 1946, x = 78.4, y = 62.0 }, note = "Fra Ysiel Windsinger." },
        }},
        { label = "Cenarion Refuge", elements = {
                { kind = "do", quest = 9730, title = "Leader of the Darkcrest",
                  coords = { map = 1946, x = 84.0, y = 77.0 }, note = "Dræb Darkcrest-nagaer syd for refuge; lederen patruljerer." },
        }},
        { label = "Cenarion Refuge", elements = {
                { kind = "do", quest = 9817, title = "Leader of the Bloodscale",
                  coords = { map = 1946, x = 83.0, y = 70.0 }, note = "Dræb Bloodscale-nagaer sydøst for refuge; lederen patruljerer." },
        }},
        { label = "Cenarion Refuge", elements = {
                { kind = "turnin", quest = 9730, title = "Leader of the Darkcrest",
                  coords = { map = 1946, x = 79.1, y = 65.3 }, note = "Aflever hos Warden Hamoot." },
                { kind = "turnin", quest = 9817, title = "Leader of the Bloodscale",
                  coords = { map = 1946, x = 79.1, y = 65.3 }, note = "Aflever hos Warden Hamoot." },
        }},
        { label = "Cenarion Refuge", elements = {
                { kind = "do", quest = 9716, title = "Disturbance at Umbrafen Lake",
                  coords = { map = 1946, x = 82.0, y = 78.0 }, note = "Undersøg Umbrafen Lake syd for refuge." },
        }},
        { label = "Cenarion Refuge", elements = {
                { kind = "turnin", quest = 9716, title = "Disturbance at Umbrafen Lake",
                  coords = { map = 1946, x = 78.4, y = 62.0 }, note = "Aflever hos Ysiel Windsinger." },
        }},
        { label = "Swamprat Post", elements = {
                { kind = "travel", coords = { map = 1946, x = 85.0, y = 54.0 }, radius = 60,
                  text = "Swamprat Post", note = "Løb nord til Horde-forposten Swamprat Post (flight point)." },
        }},
        { label = "Swamprat Post", elements = {
                { kind = "accept", quest = 9770, title = "Menacing Marshfangs",
                  coords = { map = 1946, x = 85.0, y = 54.0 }, note = "Fra Reavij." },
                { kind = "accept", quest = 9774, title = "Thick Hydra Scales",
                  coords = { map = 1946, x = 85.3, y = 54.8 }, note = "Fra Zurai." },
        }},
        { label = "Swamprat Post", elements = {
                { kind = "do", quest = 9770, title = "Menacing Marshfangs",
                  coords = { map = 1946, x = 82.0, y = 50.0 }, note = "Dræb Marshfang Rippers omkring posten." },
        }},
        { label = "Swamprat Post", elements = {
                { kind = "do", quest = 9774, title = "Thick Hydra Scales",
                  coords = { map = 1946, x = 80.0, y = 45.0 }, note = "Saml Thick Hydra Scales fra hydraer ved Serpent Lake." },
        }},
        { label = "Swamprat Post", elements = {
                { kind = "turnin", quest = 9770, title = "Menacing Marshfangs",
                  coords = { map = 1946, x = 85.0, y = 54.0 }, note = "Aflever hos Reavij." },
                { kind = "turnin", quest = 9774, title = "Thick Hydra Scales",
                  coords = { map = 1946, x = 85.3, y = 54.8 }, note = "Aflever hos Zurai." },
                { kind = "accept", quest = 9771, title = "Searching for Scout Jyoba",
                  coords = { map = 1946, x = 85.3, y = 54.8 }, note = "Opfølger fra Zurai." },
        }},
        { label = "Swamprat Post", elements = {
                { kind = "do", quest = 9771, title = "Searching for Scout Jyoba",
                  coords = { map = 1946, x = 80.8, y = 36.3 }, note = "Find Scout Jyoba ved Serpent Lake." },
                { kind = "turnin", quest = 9771, title = "Searching for Scout Jyoba",
                  coords = { map = 1946, x = 80.8, y = 36.3 }, note = "Scout Jyoba ligger såret ved den nordlige damppumpe." },
                { kind = "accept", quest = 9772, title = "Jyoba's Report",
                  coords = { map = 1946, x = 80.8, y = 36.3 }, note = "Fra Scout Jyoba." },
        }},
        { label = "Swamprat Post", elements = {
                { kind = "turnin", quest = 9772, title = "Jyoba's Report",
                  coords = { map = 1946, x = 85.3, y = 54.8 }, note = "Tilbage til Zurai." },
        }},
        { label = "Zabra'jin og troldene", elements = {
                { kind = "travel", coords = { map = 1946, x = 30.7, y = 50.9 }, radius = 60,
                  text = "Zabra'jin", note = "Følg vejen vest gennem sumpen til troldebyen Zabra'jin (flight point)." },
        }},
        { label = "Zabra'jin og troldene", elements = {
                { kind = "accept", quest = 9820, title = "WANTED: Boss Grog'ak",
                  coords = { map = 1946, x = 32.0, y = 49.3 }, note = "Wanted-plakat: Boss Grog'ak." },
                { kind = "accept", quest = 10117, title = "Wanted: Chieftain Mummaki",
                  coords = { map = 1946, x = 32.0, y = 49.3 }, note = "Wanted-plakat: Chieftain Mummaki." },
                { kind = "accept", quest = 9822, title = "Impending Attack",
                  coords = { map = 1946, x = 30.7, y = 50.9 }, note = "Fra Shadow Hunter Denjai." },
        }},
        { label = "Zabra'jin og troldene", elements = {
                { kind = "do", quest = 9820, title = "WANTED: Boss Grog'ak",
                  coords = { map = 1946, x = 27.5, y = 32.5 }, note = "Dræb Boss Grog'ak blandt Ango'rosh-ogrerne nordvest for byen." },
        }},
        { label = "Zabra'jin og troldene", elements = {
                { kind = "do", quest = 10117, title = "Wanted: Chieftain Mummaki",
                  coords = { map = 1946, x = 84.5, y = 77.5 }, note = "Dræb Chieftain Mummaki hos Umbrafen-stammen i sydøst." },
        }},
        { label = "Zabra'jin og troldene", elements = {
                { kind = "do", quest = 9822, title = "Impending Attack",
                  coords = { map = 1946, x = 36.0, y = 60.0 }, note = "Dræb Bloodscale-nagaer ved deres enklave." },
        }},
        { label = "Zabra'jin og troldene", elements = {
                { kind = "turnin", quest = 9820, title = "WANTED: Boss Grog'ak",
                  coords = { map = 1946, x = 30.7, y = 50.9 }, note = "Aflever hos Shadow Hunter Denjai." },
                { kind = "turnin", quest = 10117, title = "Wanted: Chieftain Mummaki",
                  coords = { map = 1946, x = 30.7, y = 50.9 }, note = "Aflever hos Shadow Hunter Denjai." },
                { kind = "turnin", quest = 9822, title = "Impending Attack",
                  coords = { map = 1946, x = 30.7, y = 50.9 }, note = "Aflever hos Shadow Hunter Denjai." },
                { kind = "accept", quest = 9823, title = "Us or Them",
                  coords = { map = 1946, x = 30.7, y = 50.9 }, note = "Fra Shadow Hunter Denjai." },
        }},
        { label = "Zabra'jin og troldene", elements = {
                { kind = "do", quest = 9823, title = "Us or Them",
                  coords = { map = 1946, x = 36.0, y = 60.0 }, note = "Dræb flere Bloodscale-nagaer." },
        }},
        { label = "Zabra'jin og troldene", elements = {
                { kind = "turnin", quest = 9823, title = "Us or Them",
                  coords = { map = 1946, x = 30.7, y = 50.9 }, note = "Aflever hos Shadow Hunter Denjai." },
                { kind = "accept", quest = 9841, title = "Stinging the Stingers",
                  coords = { map = 1946, x = 31.6, y = 49.2 }, note = "Fra Gambarinka i Zabra'jin." },
                { kind = "accept", quest = 9814, title = "Burstcap Mushrooms, Mon!",
                  coords = { map = 1946, x = 32.9, y = 48.9 }, note = "Fra Witch Doctor Tor'gash i Zabra'jin." },
                { kind = "do", quest = 9814, title = "Burstcap Mushrooms, Mon!",
                  coords = { map = 1946, x = 30.1, y = 50.9 }, note = "Saml Burstcap Mushrooms i sumpen nær Zabra'jin." },
        }},
        { label = "Zabra'jin og troldene", elements = {
                { kind = "do", quest = 9841, title = "Stinging the Stingers",
                  coords = { map = 1946, x = 22.2, y = 40.5 }, note = "Dræb Marsh Stingers nord/vest for byen." },
        }},
        { label = "Zabra'jin og troldene", elements = {
                { kind = "turnin", quest = 9814, title = "Burstcap Mushrooms, Mon!",
                  coords = { map = 1946, x = 32.9, y = 48.9 }, note = "Aflever hos Witch Doctor Tor'gash." },
                { kind = "turnin", quest = 9841, title = "Stinging the Stingers",
                  coords = { map = 1946, x = 31.6, y = 49.2 }, note = "Aflever hos Gambarinka." },
        }},
        { label = "Sporeggar", elements = {
                { kind = "travel", coords = { map = 1946, x = 19.7, y = 52.1 }, radius = 60,
                  text = "Sporeggar", note = "Besøg sporeling-byen Sporeggar vest i zonen." },
        }},
        { label = "Sporeggar", elements = {
                { kind = "accept", quest = 9808, title = "Glowcap Mushrooms",
                  coords = { map = 1946, x = 19.7, y = 52.1 }, note = "Fra Msshi'fn - Glowcaps bruges som valuta i Sporeggar!" },
        }},
        { label = "Sporeggar", elements = {
                { kind = "accept", quest = 9739, title = "The Sporelings' Plight",
                  coords = { map = 1946, x = 19.0, y = 62.4 }, note = "Fra Fahssn." },
                { kind = "accept", quest = 9743, title = "Natural Enemies",
                  coords = { map = 1946, x = 19.0, y = 62.4 }, note = "Fra Fahssn." },
        }},
        { label = "Sporeggar", elements = {
                { kind = "do", quest = 9739, title = "The Sporelings' Plight",
                  coords = { map = 1946, x = 15.0, y = 60.0 }, note = "Saml Spore Sacs fra Marsh Spores i Sporewind Lake." },
        }},
        { label = "Sporeggar", elements = {
                { kind = "do", quest = 9743, title = "Natural Enemies",
                  coords = { map = 1946, x = 12.0, y = 55.0 }, note = "Dræb Bog Lords og Marsh Walkers vest for byen." },
        }},
        { label = "Sporeggar", elements = {
                { kind = "do", quest = 9808, title = "Glowcap Mushrooms",
                  coords = { map = 1946, x = 16.0, y = 50.0 }, note = "Saml Glowcap Mushrooms i sumpen omkring Sporeggar." },
        }},
        { label = "Sporeggar", elements = {
                { kind = "turnin", quest = 9739, title = "The Sporelings' Plight",
                  coords = { map = 1946, x = 19.0, y = 62.4 }, note = "Aflever hos Fahssn." },
                { kind = "turnin", quest = 9743, title = "Natural Enemies",
                  coords = { map = 1946, x = 19.0, y = 62.4 }, note = "Aflever hos Fahssn." },
        }},
        { label = "Sporeggar", elements = {
                { kind = "turnin", quest = 9808, title = "Glowcap Mushrooms",
                  coords = { map = 1946, x = 19.7, y = 52.1 }, note = "Aflever hos Msshi'fn." },
        }},
        { label = "Sporeggar", elements = {
                { kind = "note", coords = { map = 1946, x = 19.8, y = 50.8 }, text = "Fhwoor Smash! (eskorte)",
                  note = "Valgfrit: eskorte-questen 'Fhwoor Smash!' giver god XP. Tryk 'Spring over' bagefter." },
        }},
        { label = "Aflever plantedelene", elements = {
                { kind = "turnin", quest = 9802, title = "Plants of Zangarmarsh",
                  coords = { map = 1946, x = 80.3, y = 64.2 }, note = "Flyv tilbage til Cenarion Refuge og aflever plantedelene hos Lauranna, når du har alle 10." },
        }},
        { label = "Ekstra: Sporeling-observation & Feralfen (valgfri)", elements = {
                { kind = "note", coords = { map = 1946, x = 78.5, y = 63.1 }, text = "Disse quests er valgfri",
                  note = "God XP hvis du mangler op til level 64. Watcher Leesa'oh-kæden er især effektiv. Spring over efter behov." },
        }},
        { label = "Ekstra: Sporeling-observation & Feralfen (valgfri)", elements = {
                { kind = "accept", quest = 9697, title = "Watcher Leesa'oh",
                  coords = { map = 1946, x = 78.5, y = 63.1 }, note = "Fra Lethyn Moonfire i Cenarion Refuge." },
        }},
        { label = "Ekstra: Sporeling-observation & Feralfen (valgfri)", elements = {
                { kind = "turnin", quest = 9697, title = "Watcher Leesa'oh",
                  coords = { map = 1946, x = 23.3, y = 66.2 }, note = "Tal med Watcher Leesa'oh vest for Sporeggar." },
                { kind = "accept", quest = 9701, title = "Observing the Sporelings",
                  coords = { map = 1946, x = 23.3, y = 66.2 }, note = "Fra Watcher Leesa'oh." },
                { kind = "do", quest = 9701, title = "Observing the Sporelings",
                  coords = { map = 1946, x = 23.3, y = 66.2 }, note = "Observér sporelingerne som beskrevet." },
                { kind = "turnin", quest = 9701, title = "Observing the Sporelings",
                  coords = { map = 1946, x = 23.3, y = 66.2 }, note = "Aflever hos Watcher Leesa'oh." },
                { kind = "accept", quest = 9702, title = "A Question of Gluttony",
                  coords = { map = 1946, x = 23.3, y = 66.2 }, note = "Fra Watcher Leesa'oh." },
                { kind = "do", quest = 9702, title = "A Question of Gluttony",
                  coords = { map = 1946, x = 23.3, y = 66.2 }, note = "Fodr en Bog Lord til den er mæt." },
                { kind = "turnin", quest = 9702, title = "A Question of Gluttony",
                  coords = { map = 1946, x = 23.3, y = 66.2 }, note = "Aflever hos Watcher Leesa'oh." },
                { kind = "accept", quest = 9708, title = "Familiar Fungi",
                  coords = { map = 1946, x = 23.3, y = 66.2 }, note = "Fra Watcher Leesa'oh." },
        }},
        { label = "Ekstra: Sporeling-observation & Feralfen (valgfri)", elements = {
                { kind = "do", quest = 9708, title = "Familiar Fungi",
                  coords = { map = 1946, x = 31.5, y = 30.7 }, note = "Find de velkendte svampe." },
        }},
        { label = "Ekstra: Sporeling-observation & Feralfen (valgfri)", elements = {
                { kind = "turnin", quest = 9708, title = "Familiar Fungi",
                  coords = { map = 1946, x = 23.3, y = 66.2 }, note = "Aflever hos Watcher Leesa'oh." },
                { kind = "accept", quest = 9709, title = "Stealing Back the Mushrooms",
                  coords = { map = 1946, x = 23.3, y = 66.2 }, note = "Fra Watcher Leesa'oh." },
        }},
        { label = "Ekstra: Sporeling-observation & Feralfen (valgfri)", elements = {
                { kind = "do", quest = 9709, title = "Stealing Back the Mushrooms",
                  coords = { map = 1946, x = 18.9, y = 7.5 }, note = "Stjæl svampene tilbage fra Bloodscale-nagaerne." },
        }},
        { label = "Ekstra: Sporeling-observation & Feralfen (valgfri)", elements = {
                { kind = "turnin", quest = 9709, title = "Stealing Back the Mushrooms",
                  coords = { map = 1946, x = 23.3, y = 66.2 }, note = "Aflever hos Watcher Leesa'oh." },
        }},
        { label = "Ekstra: Sporeling-observation & Feralfen (valgfri)", elements = {
                { kind = "accept", quest = 9786, title = "The Boha'mu Ruins",
                  coords = { map = 1946, x = 68.2, y = 49.4 }, note = "Fra Anchorite Ahuurn ved Orebor Harborage." },
                { kind = "do", quest = 9786, title = "The Boha'mu Ruins",
                  coords = { map = 1946, x = 68.2, y = 49.4 }, note = "Undersøg Boha'mu-ruinerne." },
                { kind = "turnin", quest = 9786, title = "The Boha'mu Ruins",
                  coords = { map = 1946, x = 68.2, y = 49.4 }, note = "Aflever hos Anchorite Ahuurn." },
                { kind = "accept", quest = 9782, title = "The Dead Mire",
                  coords = { map = 1946, x = 68.3, y = 50.1 }, note = "Fra Vindicator Idaar ved Orebor Harborage." },
        }},
        { label = "Ekstra: Sporeling-observation & Feralfen (valgfri)", elements = {
                { kind = "do", quest = 9782, title = "The Dead Mire",
                  coords = { map = 1946, x = 81.4, y = 38.1 }, note = "Undersøg Dead Mire nordøst i zonen." },
        }},
        { label = "Ekstra: Sporeling-observation & Feralfen (valgfri)", elements = {
                { kind = "turnin", quest = 9782, title = "The Dead Mire",
                  coords = { map = 1946, x = 68.3, y = 50.1 }, note = "Aflever hos Vindicator Idaar." },
        }},
        { label = "Videre", elements = {
                { kind = "ding", level = 64, note = "Du skal være level 64. Mangler du XP: gør de valgfri quests ovenfor færdige, eller grind naga ved Bloodscale/Darkcrest indtil du dinger." },
        }},
        { label = "Videre", elements = {
                { kind = "travel", coords = { map = 1952, x = 44.3, y = 26.3 }, radius = 100,
                  text = "Mod Terokkar Forest", note = "Følg vejen sydøst ud af Zangarmarsh mod Terokkar Forest. Qeasy skifter automatisk rute." },
        }},
    },
})
