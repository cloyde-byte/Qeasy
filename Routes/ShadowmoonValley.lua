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
                { kind = "accept", quest = 10702, title = "A Grunt's Work...",
                  coords = { map = 1948, x = 28.4, y = 26.5 }, note = "Fra Overlord Or'barokh i Shadowmoon Village." },
                { kind = "accept", quest = 10760, title = "The Sketh'lon Wreckage",
                  coords = { map = 1948, x = 31.0, y = 29.8 }, note = "Fra Sergeant Kargrul nær Shadowmoon Village." },
        }},
        { label = "Shadowmoon Village", elements = {
                { kind = "do", quest = 10702, title = "A Grunt's Work...",
                  coords = { map = 1948, x = 54.0, y = 30.5 }, note = "Fuldfør A Grunt's Work (følg kort-markøren)." },
        }},
        { label = "Shadowmoon Village", elements = {
                { kind = "do", quest = 10760, title = "The Sketh'lon Wreckage",
                  coords = { map = 1948, x = 37.7, y = 30.6 }, note = "Undersøg Sketh'lon-vraget nord for byen." },
        }},
        { label = "Shadowmoon Village", elements = {
                { kind = "turnin", quest = 10702, title = "A Grunt's Work...",
                  coords = { map = 1948, x = 28.4, y = 26.5 }, note = "Aflever hos Overlord Or'barokh." },
        }},
        { label = "Shadowmoon Village", elements = {
                { kind = "turnin", quest = 10760, title = "The Sketh'lon Wreckage",
                  coords = { map = 1948, x = 31.0, y = 29.8 }, note = "Aflever hos Sergeant Kargrul." },
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
                { kind = "accept", quest = 10481, title = "Enraged Spirits of Air",
                  coords = { map = 1948, x = 42.2, y = 45.1 }, note = "Fra Earthmender Torlok." },
                { kind = "do", quest = 10481, title = "Enraged Spirits of Air",
                  coords = { map = 1948, x = 44.0, y = 44.0 }, note = "Berolig Enraged Spirits of Air." },
                { kind = "turnin", quest = 10481, title = "Enraged Spirits of Air",
                  coords = { map = 1948, x = 42.2, y = 45.1 }, note = "Aflever hos Earthmender Torlok." },
        }},
        { label = "Ekstra: Deathforge-kæden (valgfri - god XP)", elements = {
                { kind = "note", coords = { map = 1948, x = 30.5, y = 32.4 }, text = "Disse quests er valgfri",
                  note = "God XP hvis du mangler op til level 70. Kæden fortsætter fra Blood Guard Gulmok mod Deathforge." },
        }},
        { label = "Ekstra: Deathforge-kæden (valgfri - god XP)", elements = {
                { kind = "accept", quest = 10599, title = "The Deathforge",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Fra Blood Guard Gulmok." },
        }},
        { label = "Ekstra: Deathforge-kæden (valgfri - god XP)", elements = {
                { kind = "turnin", quest = 10599, title = "The Deathforge",
                  coords = { map = 1948, x = 38.6, y = 38.2 }, note = "Rejs til Scout Zagran ved Deathforge (øst)." },
                { kind = "accept", quest = 10600, title = "Minions of the Shadow Council",
                  coords = { map = 1948, x = 38.6, y = 38.2 }, note = "Fra Scout Zagran." },
                { kind = "do", quest = 10600, title = "Minions of the Shadow Council",
                  coords = { map = 1948, x = 39.2, y = 39.4 }, note = "Dræb Shadow Council-minions." },
                { kind = "turnin", quest = 10600, title = "Minions of the Shadow Council",
                  coords = { map = 1948, x = 38.6, y = 38.2 }, note = "Aflever hos Scout Zagran." },
                { kind = "accept", quest = 10601, title = "The Fate of Kagrosh",
                  coords = { map = 1948, x = 38.6, y = 38.2 }, note = "Fra Scout Zagran." },
                { kind = "do", quest = 10601, title = "The Fate of Kagrosh",
                  coords = { map = 1948, x = 38.6, y = 38.2 }, note = "Find Kagroshs skæbne." },
                { kind = "turnin", quest = 10601, title = "The Fate of Kagrosh",
                  coords = { map = 1948, x = 38.6, y = 38.2 }, note = "Aflever hos Scout Zagran." },
                { kind = "accept", quest = 10602, title = "The Summoning Chamber",
                  coords = { map = 1948, x = 38.6, y = 38.2 }, note = "Fra Scout Zagran." },
        }},
        { label = "Ekstra: Deathforge-kæden (valgfri - god XP)", elements = {
                { kind = "do", quest = 10602, title = "The Summoning Chamber",
                  coords = { map = 1948, x = 36.8, y = 41.7 }, note = "Undersøg besværgelseskammeret." },
        }},
        { label = "Ekstra: Deathforge-kæden (valgfri - god XP)", elements = {
                { kind = "turnin", quest = 10602, title = "The Summoning Chamber",
                  coords = { map = 1948, x = 38.6, y = 38.2 }, note = "Aflever hos Scout Zagran." },
                { kind = "accept", quest = 10603, title = "Bring Down the Warbringer!",
                  coords = { map = 1948, x = 38.6, y = 38.2 }, note = "Fra Scout Zagran." },
        }},
        { label = "Ekstra: Deathforge-kæden (valgfri - god XP)", elements = {
                { kind = "do", quest = 10603, title = "Bring Down the Warbringer!",
                  coords = { map = 1948, x = 39.0, y = 46.9 }, note = "Nedlæg Warbringeren." },
        }},
        { label = "Ekstra: Deathforge-kæden (valgfri - god XP)", elements = {
                { kind = "turnin", quest = 10603, title = "Bring Down the Warbringer!",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Aflever hos Blood Guard Gulmok." },
                { kind = "accept", quest = 10604, title = "Gaining Access",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Fra Blood Guard Gulmok." },
        }},
        { label = "Ekstra: Deathforge-kæden (valgfri - god XP)", elements = {
                { kind = "do", quest = 10604, title = "Gaining Access",
                  coords = { map = 1948, x = 23.6, y = 33.2 }, note = "Skaf adgang til Deathforge." },
        }},
        { label = "Ekstra: Deathforge-kæden (valgfri - god XP)", elements = {
                { kind = "turnin", quest = 10604, title = "Gaining Access",
                  coords = { map = 1948, x = 30.5, y = 32.4 }, note = "Aflever hos Blood Guard Gulmok." },
        }},
        { label = "Ekstra: Researcher Tiorus (valgfri)", elements = {
                { kind = "accept", quest = 10672, title = "Frankly, It Makes No Sense...",
                  coords = { map = 1948, x = 30.1, y = 28.3 }, note = "Fra Researcher Tiorus i Shadowmoon Village." },
        }},
        { label = "Ekstra: Researcher Tiorus (valgfri)", elements = {
                { kind = "do", quest = 10672, title = "Frankly, It Makes No Sense...",
                  coords = { map = 1948, x = 62.2, y = 40.1 }, note = "Skaf prøverne Tiorus mangler." },
        }},
        { label = "Ekstra: Researcher Tiorus (valgfri)", elements = {
                { kind = "turnin", quest = 10672, title = "Frankly, It Makes No Sense...",
                  coords = { map = 1948, x = 30.1, y = 28.3 }, note = "Aflever hos Researcher Tiorus." },
                { kind = "accept", quest = 10673, title = "Felspine the Greater",
                  coords = { map = 1948, x = 30.1, y = 28.3 }, note = "Fra Researcher Tiorus." },
        }},
        { label = "Ekstra: Researcher Tiorus (valgfri)", elements = {
                { kind = "do", quest = 10673, title = "Felspine the Greater",
                  coords = { map = 1948, x = 56.1, y = 44.3 }, note = "Dræb Felspine the Greater." },
        }},
        { label = "Ekstra: Researcher Tiorus (valgfri)", elements = {
                { kind = "turnin", quest = 10673, title = "Felspine the Greater",
                  coords = { map = 1948, x = 30.1, y = 28.3 }, note = "Aflever hos Researcher Tiorus." },
        }},
        { label = "The Cipher of Damnation (stor valgfri kæde)", elements = {
                { kind = "accept", quest = 10513, title = "Oronok Torn-heart",
                  coords = { map = 1948, x = 42.2, y = 45.1 }, note = "Fra Earthmender Torlok - starter Oronok-kæden." },
        }},
        { label = "The Cipher of Damnation (stor valgfri kæde)", elements = {
                { kind = "note", coords = { map = 1948, x = 54.0, y = 23.5 }, text = "Oronok Torn-heart (Cipher of Damnation)",
                  note = "Aflever hos Oronok Torn-heart og følg zonens store kæde: du hjælper hans tre sønner (Grom'tor, Ar'tor, Borak) og samler cipher-fragmenterne. Fremragende XP og afslutning på dalens historie - klart den bedste vej til level 70." },
        }},
        { label = "The Cipher of Damnation (stor valgfri kæde)", elements = {
                { kind = "note", coords = { map = 1948, x = 56.0, y = 59.6 }, text = "Sanctum of the Stars / Altar of Sha'tar",
                  note = "Valgfrit: Scryers' Sanctum of the Stars (eller Aldors Altar of Sha'tar) har quests fra 69-70 og dailies - godt sted at starte dit endgame-ry." },
        }},
        { label = "Mål: level 70", elements = {
                { kind = "ding", level = 70, note = "Du skal være level 70. Mangler du XP: Cipher of Damnation-kæden (Oronok) er den mest effektive vej; ellers gør Deathforge-kæden færdig eller grind i dalen indtil du dinger." },
        }},
        { label = "Mål: level 70", elements = {
                { kind = "note", coords = { map = 1948, x = 30.0, y = 27.7 }, text = "Tillykke med level 70!",
                  note = "Du er i mål! Herfra venter Netherwing-ry (Dragonmaw-kæderne i sydøst), dungeons, heroics og Karazhan-attunement. Tak fordi du levelede med Qeasy - tryk 'Spring over' for at afslutte ruten." },
        }},
    },
})
