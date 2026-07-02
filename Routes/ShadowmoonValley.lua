local _, ns = ...

-- =========================================================================
-- Shadowmoon Valley (Horde) - level 67-70
--
-- Rækkefølgen følger Wowheads leveling-guide for Burning Crusade Classic.
-- Quest-id'er og koordinater er verificeret mod pfQuest-databasen
-- (https://github.com/shagu/pfQuest, MIT-licens, © Eric Mauser/Shagu).
-- Ruten er GENERERET af tools/plans.py - rediger ikke i hånden.
--
-- Format: grupperede steps med elementer (kind = accept|do|turnin|travel|
-- fly|hearth|train|vendor|buy|note|ding|grind). Koordinater er zone-
-- procenter (x, y) på uiMapID:
--   1948 = Shadowmoon Valley
-- =========================================================================

ns.Q:RegisterRoute({
    key = "shadowmoon-horde",
    title = "Shadowmoon Valley (Horde)",
    faction = "Horde",
    levels = "67-70",
    zones = { 1948 },
    steps = {
        { label = "Shadowmoon Village", elements = {
                { kind = "travel", coords = { map = 1948, x = 30.0, y = 27.7 }, radius = 60,
                  text = "Shadowmoon Village", note = "Horde-byen i nordvest (flight point) er din base i zonen." },
        }},
        { label = "Shadowmoon Village", elements = {
                { kind = "accept", quest = 10660, title = "What Strange Creatures...",
                  coords = { map = 1948, x = 30.1, y = 28.3 }, note = "Fra Researcher Tiorus." },
                { kind = "accept", quest = 10627, title = "Capture the Weapons",
                  coords = { map = 1948, x = 29.8, y = 31.3 }, note = "Fra Grokom Deatheye. Kræver Illidari-Bane Shard, som dropper fra Illidari-orcs i dalen - saml den op undervejs." },
                { kind = "accept", quest = 10624, title = "A Haunted History",
                  coords = { map = 1948, x = 30.0, y = 27.7 }, note = "Fra Chief Apothecary Hildagard." },
        }},
        { label = "Shadowmoon Village", elements = {
                { kind = "do", quest = 10660, title = "What Strange Creatures...",
                  coords = { map = 1948, x = 33.0, y = 25.0 }, note = "Saml prøver fra dalens mærkelige skabninger." },
        }},
        { label = "Shadowmoon Village", elements = {
                { kind = "do", quest = 10627, title = "Capture the Weapons",
                  coords = { map = 1948, x = 33.0, y = 33.0 }, note = "Erobr våben fra Shadowmoon-orcerne." },
        }},
        { label = "Shadowmoon Village", elements = {
                { kind = "do", quest = 10624, title = "A Haunted History",
                  coords = { map = 1948, x = 31.0, y = 28.0 }, note = "Undersøg den hjemsøgte historie omkring byen." },
                { kind = "turnin", quest = 10660, title = "What Strange Creatures...",
                  coords = { map = 1948, x = 30.1, y = 28.3 }, note = "Aflever hos Researcher Tiorus." },
        }},
        { label = "Shadowmoon Village", elements = {
                { kind = "turnin", quest = 10627, title = "Capture the Weapons",
                  coords = { map = 1948, x = 29.8, y = 31.3 }, note = "Aflever hos Grokom Deatheye." },
        }},
        { label = "Shadowmoon Village", elements = {
                { kind = "turnin", quest = 10624, title = "A Haunted History",
                  coords = { map = 1948, x = 30.0, y = 27.7 }, note = "Aflever hos Chief Apothecary Hildagard." },
                { kind = "accept", quest = 10625, title = "Spectrecles",
                  coords = { map = 1948, x = 30.0, y = 27.7 }, note = "Fra Hildagard - spøgelses-briller." },
                { kind = "do", quest = 10625, title = "Spectrecles",
                  coords = { map = 1948, x = 32.0, y = 30.0 }, note = "Tag Spectrecles på og hjælp de faldne orc-ånder omkring byen." },
                { kind = "turnin", quest = 10625, title = "Spectrecles",
                  coords = { map = 1948, x = 30.0, y = 27.7 }, note = "Aflever hos Chief Apothecary Hildagard." },
        }},
        { label = "Legion Hold", elements = {
                { kind = "accept", quest = 10595, title = "Besieged!",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Fra Blood Guard Gulmok." },
                { kind = "do", quest = 10595, title = "Besieged!",
                  coords = { map = 1948, x = 30.5, y = 34.0 }, note = "Bryd belejringen ved Shadowmoon Village." },
                { kind = "turnin", quest = 10595, title = "Besieged!",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Aflever hos Blood Guard Gulmok." },
                { kind = "accept", quest = 10596, title = "To Legion Hold",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Fra Blood Guard Gulmok." },
        }},
        { label = "Legion Hold", elements = {
                { kind = "do", quest = 10596, title = "To Legion Hold",
                  coords = { map = 1948, x = 25.0, y = 39.0 }, note = "Rekognoscér ved Legion Hold (sydvest)." },
        }},
        { label = "Legion Hold", elements = {
                { kind = "turnin", quest = 10596, title = "To Legion Hold",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Aflever hos Blood Guard Gulmok." },
                { kind = "accept", quest = 10597, title = "Setting Up the Bomb",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Fra Blood Guard Gulmok." },
                { kind = "accept", quest = 10598, title = "Blast the Infernals!",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Fra Blood Guard Gulmok." },
        }},
        { label = "Legion Hold", elements = {
                { kind = "do", quest = 10597, title = "Setting Up the Bomb",
                  coords = { map = 1948, x = 25.0, y = 40.0 }, note = "Placér bomben ved Legion Hold." },
                { kind = "do", quest = 10598, title = "Blast the Infernals!",
                  coords = { map = 1948, x = 24.0, y = 40.0 }, note = "Spræng Infernals ved Legion Hold." },
        }},
        { label = "Legion Hold", elements = {
                { kind = "turnin", quest = 10597, title = "Setting Up the Bomb",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Aflever hos Blood Guard Gulmok." },
                { kind = "turnin", quest = 10598, title = "Blast the Infernals!",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Aflever hos Blood Guard Gulmok." },
        }},
        { label = "Hand of Gul'dan", elements = {
                { kind = "accept", quest = 10681, title = "The Hand of Gul'dan",
                  coords = { map = 1948, x = 28.5, y = 26.6 }, note = "Fra Earthmender Splinthoof." },
        }},
        { label = "Hand of Gul'dan", elements = {
                { kind = "travel", coords = { map = 1948, x = 42.2, y = 45.1 }, radius = 60,
                  text = "Altar of Damnation", note = "Ved vulkanen Hand of Gul'dan midt i dalen - Earthmender Torlok." },
        }},
        { label = "Hand of Gul'dan", elements = {
                { kind = "turnin", quest = 10681, title = "The Hand of Gul'dan",
                  coords = { map = 1948, x = 42.2, y = 45.1 }, note = "Aflever hos Earthmender Torlok." },
                { kind = "accept", quest = 10458, title = "Enraged Spirits of Fire and Earth",
                  coords = { map = 1948, x = 42.2, y = 45.1 }, note = "Fra Earthmender Torlok." },
                { kind = "do", quest = 10458, title = "Enraged Spirits of Fire and Earth",
                  coords = { map = 1948, x = 45.0, y = 43.0 }, note = "Berolig Enraged Spirits of Fire og Earth ved vulkanen." },
                { kind = "turnin", quest = 10458, title = "Enraged Spirits of Fire and Earth",
                  coords = { map = 1948, x = 42.2, y = 45.1 }, note = "Aflever hos Earthmender Torlok." },
                { kind = "accept", quest = 10480, title = "Enraged Spirits of Water",
                  coords = { map = 1948, x = 42.2, y = 45.1 }, note = "Fra Earthmender Torlok." },
        }},
        { label = "Hand of Gul'dan", elements = {
                { kind = "do", quest = 10480, title = "Enraged Spirits of Water",
                  coords = { map = 1948, x = 40.0, y = 48.0 }, note = "Berolig Enraged Spirits of Water." },
        }},
        { label = "Hand of Gul'dan", elements = {
                { kind = "turnin", quest = 10480, title = "Enraged Spirits of Water",
                  coords = { map = 1948, x = 42.2, y = 45.1 }, note = "Aflever hos Earthmender Torlok." },
        }},
        { label = "The Cipher of Damnation og afslutning", elements = {
                { kind = "accept", quest = 10513, title = "Oronok Torn-heart",
                  coords = { map = 1948, x = 42.2, y = 45.1 }, note = "Fra Earthmender Torlok - starter Oronok-kæden." },
        }},
        { label = "The Cipher of Damnation og afslutning", elements = {
                { kind = "note", coords = { map = 1948, x = 54.0, y = 23.5 }, text = "Oronok Torn-heart (Cipher of Damnation)",
                  note = "Aflever hos Oronok Torn-heart og følg zonens store kæde: du hjælper hans tre sønner (Grom'tor, Ar'tor, Borak) og samler cipher-fragmenterne. Fremragende XP og afslutning på dalens historie. Tryk 'Spring over', når kæden er færdig." },
        }},
        { label = "The Cipher of Damnation og afslutning", elements = {
                { kind = "note", coords = { map = 1948, x = 56.0, y = 59.6 }, text = "Sanctum of the Stars / Altar of Sha'tar",
                  note = "Valgfrit: Scryers' Sanctum of the Stars (eller Aldors Altar of Sha'tar) har quests fra 69-70 og dailies - godt sted at starte dit endgame-ry." },
        }},
        { label = "The Cipher of Damnation og afslutning", elements = {
                { kind = "ding", level = 70 },
        }},
        { label = "The Cipher of Damnation og afslutning", elements = {
                { kind = "note", coords = { map = 1948, x = 30.0, y = 27.7 }, text = "Tillykke med level 70!",
                  note = "Du er i mål! Herfra venter Netherwing-ry (Dragonmaw-kæderne i sydøst), dungeons, heroics og Karazhan-attunement. Tak fordi du levelede med Qeasy - tryk 'Spring over' for at afslutte ruten." },
        }},
    },
})
