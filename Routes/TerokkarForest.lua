local _, ns = ...

-- =========================================================================
-- Terokkar Forest (Horde) - level 62-65
--
-- Rækkefølgen følger Wowheads leveling-guide for Burning Crusade Classic.
-- Quest-id'er og koordinater er verificeret mod pfQuest-databasen
-- (https://github.com/shagu/pfQuest, MIT-licens, © Eric Mauser/Shagu).
-- Ruten er GENERERET af tools/plans.py - rediger ikke i hånden.
--
-- Format: grupperede steps med elementer (kind = accept|do|turnin|travel|
-- fly|hearth|train|vendor|buy|note|ding|grind). Koordinater er zone-
-- procenter (x, y) på uiMapID:
--   1952 = Terokkar Forest, 1951 = Nagrand
-- =========================================================================

ns.Q:RegisterRoute({
    key = "terokkar-horde",
    title = "Terokkar Forest (Horde)",
    faction = "Horde",
    levels = "62-65",
    zones = { 1952 },
    next = "nagrand-horde",
    steps = {
        { label = "Cenarion Thicket", elements = {
                { kind = "travel", coords = { map = 1952, x = 44.3, y = 26.3 }, radius = 60,
                  text = "Cenarion Thicket", note = "Fra Zangarmarsh ind i Terokkar; Cenarion Thicket ligger ved indgangen." },
                { kind = "accept", quest = 9971, title = "Clues in the Thicket",
                  coords = { map = 1952, x = 44.3, y = 26.3 }, note = "Fra Earthbinder Tavgren." },
                { kind = "do", quest = 9971, title = "Clues in the Thicket",
                  coords = { map = 1952, x = 46.0, y = 24.0 }, note = "Undersøg spor i thicket omkring det ødelagte tårn." },
                { kind = "turnin", quest = 9971, title = "Clues in the Thicket",
                  coords = { map = 1952, x = 44.3, y = 26.3 }, note = "Aflever hos Earthbinder Tavgren." },
                { kind = "accept", quest = 9968, title = "Strange Energy",
                  coords = { map = 1952, x = 44.3, y = 26.3 }, note = "Fra Earthbinder Tavgren." },
                { kind = "do", quest = 9968, title = "Strange Energy",
                  coords = { map = 1952, x = 45.0, y = 28.0 }, note = "Dræb korrupte dyr og undersøg den mærkelige energi." },
                { kind = "turnin", quest = 9968, title = "Strange Energy",
                  coords = { map = 1952, x = 44.3, y = 26.3 }, note = "Aflever hos Earthbinder Tavgren." },
        }},
        { label = "Stonebreaker Hold", elements = {
                { kind = "travel", coords = { map = 1952, x = 49.2, y = 45.7 }, radius = 60,
                  text = "Stonebreaker Hold", note = "Løb syd til Horde-basen Stonebreaker Hold (flight point)." },
                { kind = "accept", quest = 10027, title = "Magical Disturbances",
                  coords = { map = 1952, x = 48.8, y = 45.7 }, note = "Fra Kurgatok." },
                { kind = "accept", quest = 9987, title = "Stymying the Arakkoa",
                  coords = { map = 1952, x = 49.0, y = 44.6 }, note = "Fra Rokag." },
                { kind = "accept", quest = 10000, title = "An Unwelcome Presence",
                  coords = { map = 1952, x = 48.8, y = 45.7 }, note = "Fra Kurgatok - arakkoa-spionage." },
                { kind = "accept", quest = 10034, title = "Wanted: Bonelashers Dead!",
                  coords = { map = 1952, x = 49.8, y = 45.3 }, note = "Wanted-plakat: Bonelashers." },
                { kind = "do", quest = 10027, title = "Magical Disturbances",
                  coords = { map = 1952, x = 54.0, y = 35.0 }, note = "Klar de magiske forstyrrelser omkring Tuurem nordøst for holden." },
                { kind = "do", quest = 9987, title = "Stymying the Arakkoa",
                  coords = { map = 1952, x = 54.0, y = 36.0 }, note = "Dræb arakkoa ved Tuurem." },
                { kind = "do", quest = 10034, title = "Wanted: Bonelashers Dead!",
                  coords = { map = 1952, x = 52.0, y = 40.0 }, note = "Dræb Bonelasher-behemoths i skoven." },
                { kind = "turnin", quest = 10027, title = "Magical Disturbances",
                  coords = { map = 1952, x = 48.8, y = 45.7 }, note = "Aflever hos Kurgatok." },
                { kind = "turnin", quest = 9987, title = "Stymying the Arakkoa",
                  coords = { map = 1952, x = 49.0, y = 44.6 }, note = "Aflever hos Rokag." },
                { kind = "turnin", quest = 10034, title = "Wanted: Bonelashers Dead!",
                  coords = { map = 1952, x = 49.2, y = 45.9 }, note = "Aflever hos Mawg Grimshot." },
                { kind = "accept", quest = 10036, title = "Torgos!",
                  coords = { map = 1952, x = 49.2, y = 45.9 }, note = "Fra Mawg Grimshot - kæmpegribben Torgos." },
                { kind = "do", quest = 10036, title = "Torgos!",
                  coords = { map = 1952, x = 55.0, y = 42.0 }, note = "Torgos kredser over Bonelasher-territoriet." },
                { kind = "turnin", quest = 10036, title = "Torgos!",
                  coords = { map = 1952, x = 49.2, y = 45.9 }, note = "Aflever hos Mawg Grimshot." },
                { kind = "do", quest = 10000, title = "An Unwelcome Presence",
                  coords = { map = 1952, x = 63.4, y = 42.7 }, note = "Find den arakkoiske forbindelse ved Firewing Point." },
                { kind = "turnin", quest = 10000, title = "An Unwelcome Presence",
                  coords = { map = 1952, x = 63.4, y = 42.7 }, note = "Aflever hos Shadowstalker Kaide nær Firewing Point." },
                { kind = "accept", quest = 10003, title = "The Firewing Liaison",
                  coords = { map = 1952, x = 63.4, y = 42.7 }, note = "Fra Shadowstalker Kaide." },
                { kind = "accept", quest = 10008, title = "What Happens in Terokkar Stays in Terokkar",
                  coords = { map = 1952, x = 63.4, y = 42.7 }, note = "Fra Shadowstalker Kaide." },
                { kind = "do", quest = 10003, title = "The Firewing Liaison",
                  coords = { map = 1952, x = 65.0, y = 40.0 }, note = "Efterlad den falske ordre for Firewing-liaisonen." },
                { kind = "do", quest = 10008, title = "What Happens in Terokkar Stays in Terokkar",
                  coords = { map = 1952, x = 66.0, y = 39.0 }, note = "Dræb blood elves ved Firewing Point." },
                { kind = "turnin", quest = 10003, title = "The Firewing Liaison",
                  coords = { map = 1952, x = 63.4, y = 42.7 }, note = "Aflever hos Shadowstalker Kaide." },
                { kind = "turnin", quest = 10008, title = "What Happens in Terokkar Stays in Terokkar",
                  coords = { map = 1952, x = 63.4, y = 42.7 }, note = "Aflever hos Shadowstalker Kaide." },
        }},
        { label = "Shattrath City", elements = {
                { kind = "travel", coords = { map = 1952, x = 34.0, y = 22.5 }, radius = 80,
                  text = "Shattrath City", note = "Besøg Shattrath City i nordvest: hent flight point'et og overvej at binde din hearthstone - Outlands centrale by." },
                { kind = "note", coords = { map = 1952, x = 34.0, y = 22.5 }, text = "Shattrath og Aldor/Scryers",
                  note = "Se A'dal i Terrace of Light og tag byens quests. Valget mellem Aldor og Scryers kan vente - bind dig ikke endnu. Tryk 'Spring over' bagefter." },
        }},
        { label = "Bone Wastes: Refugee Caravan", elements = {
                { kind = "travel", coords = { map = 1952, x = 37.7, y = 51.3 }, radius = 60,
                  text = "Refugee Caravan", note = "Syd for Shattrath ligger Bone Wastes; flygtninge-karavanen har quests." },
                { kind = "accept", quest = 10852, title = "Missing Friends",
                  coords = { map = 1952, x = 37.7, y = 51.3 }, note = "Fra Ethan - børnene er bortført." },
                { kind = "do", quest = 10852, title = "Missing Friends",
                  coords = { map = 1952, x = 36.0, y = 65.0 }, note = "Befri de fangne børn i arakkoa-landsbyen Veil Skith sydvest i skoven." },
                { kind = "turnin", quest = 10852, title = "Missing Friends",
                  coords = { map = 1952, x = 37.7, y = 51.3 }, note = "Aflever hos Ethan." },
                { kind = "accept", quest = 10878, title = "Before Darkness Falls",
                  coords = { map = 1952, x = 37.8, y = 51.8 }, note = "Fra Mekeda." },
                { kind = "do", quest = 10878, title = "Before Darkness Falls",
                  coords = { map = 1952, x = 40.0, y = 55.0 }, note = "Klar opgaven ved Auchindouns ringmur, før mørket falder." },
                { kind = "turnin", quest = 10878, title = "Before Darkness Falls",
                  coords = { map = 1952, x = 37.8, y = 51.8 }, note = "Aflever hos Mekeda." },
        }},
        { label = "Afslutning", elements = {
                { kind = "ding", level = 65 },
                { kind = "note", coords = { map = 1952, x = 49.2, y = 45.7 }, text = "Ryd op i Terokkar",
                  note = "Valgfrit: ryd resterende quests (Auchindoun-ringen, Skettis-forløbere, Sha'tari Base Camp i syd) indtil ca. level 64-65.", optional = true },
                { kind = "travel", coords = { map = 1951, x = 55.5, y = 37.5 }, radius = 100,
                  text = "Mod Nagrand", note = "Følg vejen vest ud af Terokkar mod Nagrand. Qeasy skifter automatisk rute." },
        }},
    },
})
