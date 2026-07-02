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
        }},
        { label = "Cenarion Thicket", elements = {
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
        }},
        { label = "Stonebreaker Hold", elements = {
                { kind = "accept", quest = 10027, title = "Magical Disturbances",
                  coords = { map = 1952, x = 48.8, y = 45.7 }, note = "Fra Kurgatok." },
                { kind = "accept", quest = 9987, title = "Stymying the Arakkoa",
                  coords = { map = 1952, x = 49.0, y = 44.6 }, note = "Fra Rokag." },
                { kind = "accept", quest = 10000, title = "An Unwelcome Presence",
                  coords = { map = 1952, x = 48.8, y = 45.7 }, note = "Fra Kurgatok - arakkoa-spionage." },
                { kind = "accept", quest = 10034, title = "Wanted: Bonelashers Dead!",
                  coords = { map = 1952, x = 49.8, y = 45.3 }, note = "Wanted-plakat: Bonelashers." },
        }},
        { label = "Stonebreaker Hold", elements = {
                { kind = "do", quest = 10027, title = "Magical Disturbances",
                  coords = { map = 1952, x = 54.0, y = 35.0 }, note = "Klar de magiske forstyrrelser omkring Tuurem nordøst for holden." },
                { kind = "do", quest = 9987, title = "Stymying the Arakkoa",
                  coords = { map = 1952, x = 54.0, y = 36.0 }, note = "Dræb arakkoa ved Tuurem." },
        }},
        { label = "Stonebreaker Hold", elements = {
                { kind = "do", quest = 10034, title = "Wanted: Bonelashers Dead!",
                  coords = { map = 1952, x = 52.0, y = 40.0 }, note = "Dræb Bonelasher-behemoths i skoven." },
        }},
        { label = "Stonebreaker Hold", elements = {
                { kind = "turnin", quest = 10027, title = "Magical Disturbances",
                  coords = { map = 1952, x = 48.8, y = 45.7 }, note = "Aflever hos Kurgatok." },
                { kind = "turnin", quest = 9987, title = "Stymying the Arakkoa",
                  coords = { map = 1952, x = 49.0, y = 44.6 }, note = "Aflever hos Rokag." },
                { kind = "turnin", quest = 10034, title = "Wanted: Bonelashers Dead!",
                  coords = { map = 1952, x = 49.2, y = 45.9 }, note = "Aflever hos Mawg Grimshot." },
                { kind = "accept", quest = 10036, title = "Torgos!",
                  coords = { map = 1952, x = 49.2, y = 45.9 }, note = "Fra Mawg Grimshot - kæmpegribben Torgos." },
        }},
        { label = "Stonebreaker Hold", elements = {
                { kind = "do", quest = 10036, title = "Torgos!",
                  coords = { map = 1952, x = 55.0, y = 42.0 }, note = "Torgos kredser over Bonelasher-territoriet." },
        }},
        { label = "Stonebreaker Hold", elements = {
                { kind = "turnin", quest = 10036, title = "Torgos!",
                  coords = { map = 1952, x = 49.2, y = 45.9 }, note = "Aflever hos Mawg Grimshot." },
        }},
        { label = "Stonebreaker Hold", elements = {
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
        }},
        { label = "Stonebreaker Hold", elements = {
                { kind = "do", quest = 10008, title = "What Happens in Terokkar Stays in Terokkar",
                  coords = { map = 1952, x = 66.0, y = 39.0 }, note = "Dræb blood elves ved Firewing Point." },
        }},
        { label = "Stonebreaker Hold", elements = {
                { kind = "turnin", quest = 10003, title = "The Firewing Liaison",
                  coords = { map = 1952, x = 63.4, y = 42.7 }, note = "Aflever hos Shadowstalker Kaide." },
                { kind = "turnin", quest = 10008, title = "What Happens in Terokkar Stays in Terokkar",
                  coords = { map = 1952, x = 63.4, y = 42.7 }, note = "Aflever hos Shadowstalker Kaide." },
        }},
        { label = "Shattrath City", elements = {
                { kind = "travel", coords = { map = 1952, x = 34.0, y = 22.5 }, radius = 80,
                  text = "Shattrath City", note = "Besøg Shattrath City i nordvest: hent flight point'et og overvej at binde din hearthstone - Outlands centrale by." },
        }},
        { label = "Shattrath City", elements = {
                { kind = "note", coords = { map = 1952, x = 34.0, y = 22.5 }, text = "Shattrath og Aldor/Scryers",
                  note = "Se A'dal i Terrace of Light og tag byens quests. Valget mellem Aldor og Scryers kan vente - bind dig ikke endnu. Tryk 'Spring over' bagefter." },
        }},
        { label = "Bone Wastes: Refugee Caravan", elements = {
                { kind = "travel", coords = { map = 1952, x = 37.7, y = 51.3 }, radius = 60,
                  text = "Refugee Caravan", note = "Syd for Shattrath ligger Bone Wastes; flygtninge-karavanen har quests." },
        }},
        { label = "Bone Wastes: Refugee Caravan", elements = {
                { kind = "accept", quest = 10852, title = "Missing Friends",
                  coords = { map = 1952, x = 37.7, y = 51.3 }, note = "Fra Ethan - børnene er bortført." },
        }},
        { label = "Bone Wastes: Refugee Caravan", elements = {
                { kind = "do", quest = 10852, title = "Missing Friends",
                  coords = { map = 1952, x = 36.0, y = 65.0 }, note = "Befri de fangne børn i arakkoa-landsbyen Veil Skith sydvest i skoven." },
        }},
        { label = "Bone Wastes: Refugee Caravan", elements = {
                { kind = "turnin", quest = 10852, title = "Missing Friends",
                  coords = { map = 1952, x = 37.7, y = 51.3 }, note = "Aflever hos Ethan." },
                { kind = "accept", quest = 10878, title = "Before Darkness Falls",
                  coords = { map = 1952, x = 37.8, y = 51.8 }, note = "Fra Mekeda." },
        }},
        { label = "Bone Wastes: Refugee Caravan", elements = {
                { kind = "do", quest = 10878, title = "Before Darkness Falls",
                  coords = { map = 1952, x = 40.0, y = 55.0 }, note = "Klar opgaven ved Auchindouns ringmur, før mørket falder." },
        }},
        { label = "Bone Wastes: Refugee Caravan", elements = {
                { kind = "turnin", quest = 10878, title = "Before Darkness Falls",
                  coords = { map = 1952, x = 37.8, y = 51.8 }, note = "Aflever hos Mekeda." },
        }},
        { label = "Ekstra: Stonebreaker-quests (valgfri - god XP)", elements = {
                { kind = "note", coords = { map = 1952, x = 49.2, y = 45.7 }, text = "Disse quests er valgfri",
                  note = "De næste quests er ikke strengt nødvendige, men giver den XP der skal til for at ramme level 65. Spring dem over med 'Spring over', hvis du hellere vil grinde." },
        }},
        { label = "Ekstra: Stonebreaker-quests (valgfri - god XP)", elements = {
                { kind = "accept", quest = 10018, title = "Vestments of the Wolf Spirit",
                  coords = { map = 1952, x = 50.2, y = 46.4 }, note = "Fra Malukaz i Stonebreaker Hold." },
        }},
        { label = "Ekstra: Stonebreaker-quests (valgfri - god XP)", elements = {
                { kind = "do", quest = 10018, title = "Vestments of the Wolf Spirit",
                  coords = { map = 1952, x = 53.7, y = 36.7 }, note = "Saml ulve-dele fra Warp Stalkers/ulve nær holden." },
        }},
        { label = "Ekstra: Stonebreaker-quests (valgfri - god XP)", elements = {
                { kind = "turnin", quest = 10018, title = "Vestments of the Wolf Spirit",
                  coords = { map = 1952, x = 50.2, y = 46.4 }, note = "Aflever hos Malukaz." },
                { kind = "accept", quest = 10023, title = "Patriarch Ironjaw",
                  coords = { map = 1952, x = 50.2, y = 46.4 }, note = "Fra Malukaz." },
        }},
        { label = "Ekstra: Stonebreaker-quests (valgfri - god XP)", elements = {
                { kind = "do", quest = 10023, title = "Patriarch Ironjaw",
                  coords = { map = 1952, x = 65.5, y = 34.9 }, note = "Dræb Patriarch Ironjaw (stor clefthoof) syd for holden." },
        }},
        { label = "Ekstra: Stonebreaker-quests (valgfri - god XP)", elements = {
                { kind = "turnin", quest = 10023, title = "Patriarch Ironjaw",
                  coords = { map = 1952, x = 50.2, y = 46.4 }, note = "Aflever hos Malukaz." },
                { kind = "accept", quest = 10791, title = "Welcoming the Wolf Spirit",
                  coords = { map = 1952, x = 50.2, y = 46.4 }, note = "Fra Malukaz." },
                { kind = "do", quest = 10791, title = "Welcoming the Wolf Spirit",
                  coords = { map = 1952, x = 50.2, y = 46.4 }, note = "Fuldfør ritualet for ulveånden." },
                { kind = "turnin", quest = 10791, title = "Welcoming the Wolf Spirit",
                  coords = { map = 1952, x = 50.2, y = 46.4 }, note = "Aflever hos Malukaz." },
                { kind = "accept", quest = 9993, title = "Olemba Seed Oil",
                  coords = { map = 1952, x = 50.1, y = 44.9 }, note = "Fra Rakoria i Stonebreaker Hold." },
        }},
        { label = "Ekstra: Stonebreaker-quests (valgfri - god XP)", elements = {
                { kind = "do", quest = 9993, title = "Olemba Seed Oil",
                  coords = { map = 1952, x = 53.3, y = 35.9 }, note = "Saml Olemba-frø fra arakkoa-området." },
        }},
        { label = "Ekstra: Stonebreaker-quests (valgfri - god XP)", elements = {
                { kind = "turnin", quest = 9993, title = "Olemba Seed Oil",
                  coords = { map = 1952, x = 50.1, y = 44.9 }, note = "Aflever hos Rakoria." },
                { kind = "accept", quest = 10201, title = "And Now, the Moment of Truth",
                  coords = { map = 1952, x = 50.1, y = 44.9 }, note = "Fra Rakoria." },
                { kind = "do", quest = 10201, title = "And Now, the Moment of Truth",
                  coords = { map = 1952, x = 49.8, y = 45.3 }, note = "Fuldfør Rakorias opgave." },
                { kind = "turnin", quest = 10201, title = "And Now, the Moment of Truth",
                  coords = { map = 1952, x = 50.1, y = 44.9 }, note = "Aflever hos Rakoria." },
                { kind = "accept", quest = 10039, title = "Speak with Scout Neftis",
                  coords = { map = 1952, x = 48.9, y = 44.6 }, note = "Fra Advisor Faila i Stonebreaker Hold." },
        }},
        { label = "Ekstra: Stonebreaker-quests (valgfri - god XP)", elements = {
                { kind = "turnin", quest = 10039, title = "Speak with Scout Neftis",
                  coords = { map = 1952, x = 39.0, y = 43.7 }, note = "Tal med Scout Neftis vest for holden." },
                { kind = "accept", quest = 10041, title = "Who Are They?",
                  coords = { map = 1952, x = 39.0, y = 43.7 }, note = "Fra Scout Neftis." },
                { kind = "do", quest = 10041, title = "Who Are They?",
                  coords = { map = 1952, x = 39.0, y = 43.7 }, note = "Undersøg Shadow Council-arakkoaerne." },
                { kind = "turnin", quest = 10041, title = "Who Are They?",
                  coords = { map = 1952, x = 39.0, y = 43.7 }, note = "Aflever hos Scout Neftis." },
                { kind = "accept", quest = 10043, title = "Kill the Shadow Council!",
                  coords = { map = 1952, x = 39.0, y = 43.7 }, note = "Fra Scout Neftis." },
                { kind = "do", quest = 10043, title = "Kill the Shadow Council!",
                  coords = { map = 1952, x = 39.4, y = 40.6 }, note = "Dræb Shadow Council-medlemmerne." },
        }},
        { label = "Ekstra: Stonebreaker-quests (valgfri - god XP)", elements = {
                { kind = "turnin", quest = 10043, title = "Kill the Shadow Council!",
                  coords = { map = 1952, x = 48.9, y = 44.6 }, note = "Aflever hos Advisor Faila." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "travel", coords = { map = 1952, x = 31.3, y = 76.0 }, radius = 60,
                  text = "Sha'tari Base Camp", note = "Løb syd til Sha'tari Base Camp ved Auchindoun (flight point)." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "accept", quest = 10913, title = "An Improper Burial",
                  coords = { map = 1952, x = 31.0, y = 76.1 }, note = "Fra Commander Ra'vaj." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "do", quest = 10913, title = "An Improper Burial",
                  coords = { map = 1952, x = 34.5, y = 75.8 }, note = "Fuldfør begravelsen ved Auchindoun." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "turnin", quest = 10913, title = "An Improper Burial",
                  coords = { map = 1952, x = 31.0, y = 76.1 }, note = "Aflever hos Commander Ra'vaj." },
                { kind = "accept", quest = 10914, title = "A Hero Is Needed",
                  coords = { map = 1952, x = 31.0, y = 76.1 }, note = "Fra Commander Ra'vaj." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "do", quest = 10914, title = "A Hero Is Needed",
                  coords = { map = 1952, x = 40.9, y = 70.3 }, note = "Fuldfør opgaven." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "turnin", quest = 10914, title = "A Hero Is Needed",
                  coords = { map = 1952, x = 31.0, y = 76.1 }, note = "Aflever hos Commander Ra'vaj." },
                { kind = "accept", quest = 10915, title = "The Fallen Exarch",
                  coords = { map = 1952, x = 31.0, y = 76.1 }, note = "Fra Commander Ra'vaj." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "do", quest = 10915, title = "The Fallen Exarch",
                  coords = { map = 1952, x = 35.8, y = 65.6 }, note = "Dræb den faldne exarch." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "turnin", quest = 10915, title = "The Fallen Exarch",
                  coords = { map = 1952, x = 31.0, y = 76.1 }, note = "Aflever hos Commander Ra'vaj." },
                { kind = "accept", quest = 10922, title = "Digging Through Bones",
                  coords = { map = 1952, x = 31.3, y = 76.1 }, note = "Fra Chief Archaeologist Letoll / Dwarfowitz i lejren." },
                { kind = "do", quest = 10922, title = "Digging Through Bones",
                  coords = { map = 1952, x = 31.0, y = 76.2 }, note = "Grav ved knoglemarken." },
                { kind = "turnin", quest = 10922, title = "Digging Through Bones",
                  coords = { map = 1952, x = 31.0, y = 76.2 }, note = "Aflever hos Dwarfowitz." },
                { kind = "accept", quest = 10929, title = "Fumping",
                  coords = { map = 1952, x = 31.0, y = 76.2 }, note = "Fra Dwarfowitz - 'Fumping'." },
                { kind = "do", quest = 10929, title = "Fumping",
                  coords = { map = 1952, x = 31.0, y = 76.2 }, note = "Brug fumpemaskinen på sandet og dræb det der kommer op." },
                { kind = "turnin", quest = 10929, title = "Fumping",
                  coords = { map = 1952, x = 31.0, y = 76.2 }, note = "Aflever hos Dwarfowitz." },
                { kind = "accept", quest = 10930, title = "The Big Bone Worm",
                  coords = { map = 1952, x = 31.0, y = 76.2 }, note = "Fra Dwarfowitz." },
                { kind = "do", quest = 10930, title = "The Big Bone Worm",
                  coords = { map = 1952, x = 31.0, y = 76.2 }, note = "Dræb den store bone worm." },
                { kind = "turnin", quest = 10930, title = "The Big Bone Worm",
                  coords = { map = 1952, x = 31.0, y = 76.2 }, note = "Aflever hos Dwarfowitz." },
                { kind = "accept", quest = 10873, title = "Taken in the Night",
                  coords = { map = 1952, x = 31.4, y = 75.7 }, note = "Fra Scout Navrin i lejren." },
                { kind = "do", quest = 10873, title = "Taken in the Night",
                  coords = { map = 1952, x = 31.4, y = 75.7 }, note = "Undersøg de forsvundne om natten." },
                { kind = "turnin", quest = 10873, title = "Taken in the Night",
                  coords = { map = 1952, x = 31.4, y = 75.7 }, note = "Aflever hos Scout Navrin." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "accept", quest = 10920, title = "For the Fallen",
                  coords = { map = 1952, x = 49.7, y = 76.2 }, note = "Fra Vindicator Haylen (nordøst for lejren)." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "do", quest = 10920, title = "For the Fallen",
                  coords = { map = 1952, x = 37.6, y = 66.9 }, note = "Saml for de faldne." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "turnin", quest = 10920, title = "For the Fallen",
                  coords = { map = 1952, x = 49.7, y = 76.2 }, note = "Aflever hos Vindicator Haylen." },
                { kind = "accept", quest = 10921, title = "Terokkarantula",
                  coords = { map = 1952, x = 49.7, y = 76.2 }, note = "Fra Vindicator Haylen." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "do", quest = 10921, title = "Terokkarantula",
                  coords = { map = 1952, x = 54.3, y = 81.8 }, note = "Dræb Terokkarantula." },
        }},
        { label = "Ekstra: Auchindoun & Sha'tari-lejr syd (valgfri)", elements = {
                { kind = "turnin", quest = 10921, title = "Terokkarantula",
                  coords = { map = 1952, x = 49.7, y = 76.2 }, note = "Aflever hos Vindicator Haylen." },
        }},
        { label = "Videre", elements = {
                { kind = "ding", level = 65, note = "Du skal være level 65. Mangler du stadig XP: gør flere af de valgfri quests ovenfor færdige, eller grind arakkoa ved Firewing Point (70,37) eller Auchenai i Bone Wastes indtil du dinger." },
        }},
        { label = "Videre", elements = {
                { kind = "travel", coords = { map = 1951, x = 55.5, y = 37.5 }, radius = 100,
                  text = "Mod Nagrand", note = "Følg vejen vest ud af Terokkar mod Nagrand. Qeasy skifter automatisk rute." },
        }},
    },
})
