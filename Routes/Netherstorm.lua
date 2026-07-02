local _, ns = ...

-- =========================================================================
-- Netherstorm (Horde) - level 67-69
--
-- Rækkefølgen følger Wowheads leveling-guide for Burning Crusade Classic.
-- Quest-id'er og koordinater er verificeret mod pfQuest-databasen
-- (https://github.com/shagu/pfQuest, MIT-licens, © Eric Mauser/Shagu).
-- Ruten er GENERERET af tools/plans.py - rediger ikke i hånden.
--
-- Format: grupperede steps med elementer (kind = accept|do|turnin|travel|
-- fly|hearth|train|vendor|buy|note|ding|grind). Koordinater er zone-
-- procenter (x, y) på uiMapID:
--   1953 = Netherstorm, 1948 = Shadowmoon Valley
-- =========================================================================

ns.Q:RegisterRoute({
    key = "netherstorm-horde",
    title = "Netherstorm (Horde)",
    faction = "Horde",
    levels = "67-69",
    zones = { 1953 },
    next = "shadowmoon-horde",
    steps = {
        { label = "Area 52", elements = {
                { kind = "travel", coords = { map = 1953, x = 32.7, y = 65.0 }, radius = 60,
                  text = "Area 52", note = "Goblin-byen Area 52 er din base i Netherstorm (flight point). Bind evt. din hearthstone her." },
        }},
        { label = "Area 52", elements = {
                { kind = "accept", quest = 10261, title = "Wanted: Annihilator Servo!",
                  coords = { map = 1953, x = 32.1, y = 64.6 }, note = "Wanted-plakat." },
                { kind = "accept", quest = 10206, title = "Pick Your Part",
                  coords = { map = 1953, x = 33.0, y = 64.7 }, note = "Fra Papa Wheeler." },
                { kind = "accept", quest = 10189, title = "Manaforge B'naar",
                  coords = { map = 1953, x = 32.0, y = 64.1 }, note = "Fra Spymaster Thalodien - Manaforge B'naar." },
        }},
        { label = "Area 52", elements = {
                { kind = "do", quest = 10261, title = "Wanted: Annihilator Servo!",
                  coords = { map = 1953, x = 24.0, y = 68.0 }, note = "Dræb Annihilator Servo ved manaforge B'naar (sydvest)." },
        }},
        { label = "Area 52", elements = {
                { kind = "do", quest = 10206, title = "Pick Your Part",
                  coords = { map = 1953, x = 30.0, y = 62.0 }, note = "Saml robot-dele fra vraget omkring Area 52." },
        }},
        { label = "Area 52", elements = {
                { kind = "do", quest = 10189, title = "Manaforge B'naar",
                  coords = { map = 1953, x = 23.2, y = 68.2 }, note = "Spionér på Manaforge B'naar." },
        }},
        { label = "Area 52", elements = {
                { kind = "turnin", quest = 10261, title = "Wanted: Annihilator Servo!",
                  coords = { map = 1953, x = 33.0, y = 64.7 }, note = "Aflever hos Papa Wheeler." },
                { kind = "turnin", quest = 10206, title = "Pick Your Part",
                  coords = { map = 1953, x = 33.0, y = 64.7 }, note = "Aflever hos Papa Wheeler." },
                { kind = "turnin", quest = 10189, title = "Manaforge B'naar",
                  coords = { map = 1953, x = 32.0, y = 64.1 }, note = "Tilbage til Spymaster Thalodien." },
        }},
        { label = "Manaforge-nedlukningen (Consortium/Aldor)", elements = {
                { kind = "accept", quest = 10193, title = "High Value Targets",
                  coords = { map = 1953, x = 32.0, y = 64.1 }, note = "Fra Spymaster Thalodien." },
        }},
        { label = "Manaforge-nedlukningen (Consortium/Aldor)", elements = {
                { kind = "do", quest = 10193, title = "High Value Targets",
                  coords = { map = 1953, x = 23.0, y = 69.0 }, note = "Dræb high value targets ved Manaforge B'naar." },
        }},
        { label = "Manaforge-nedlukningen (Consortium/Aldor)", elements = {
                { kind = "turnin", quest = 10193, title = "High Value Targets",
                  coords = { map = 1953, x = 32.0, y = 64.1 }, note = "Aflever hos Spymaster Thalodien." },
                { kind = "accept", quest = 10329, title = "Shutting Down Manaforge B'naar",
                  coords = { map = 1953, x = 32.0, y = 64.1 }, note = "Fra Spymaster Thalodien." },
        }},
        { label = "Manaforge-nedlukningen (Consortium/Aldor)", elements = {
                { kind = "do", quest = 10329, title = "Shutting Down Manaforge B'naar",
                  coords = { map = 1953, x = 23.2, y = 68.2 }, note = "Luk Manaforge B'naar ned via konsollen (ryd vagterne)." },
        }},
        { label = "Manaforge-nedlukningen (Consortium/Aldor)", elements = {
                { kind = "turnin", quest = 10329, title = "Shutting Down Manaforge B'naar",
                  coords = { map = 1953, x = 32.0, y = 64.1 }, note = "Aflever hos Spymaster Thalodien." },
                { kind = "accept", quest = 10194, title = "Stealth Flight",
                  coords = { map = 1953, x = 32.0, y = 64.1 }, note = "Stealth-flyvning." },
        }},
        { label = "Manaforge-nedlukningen (Consortium/Aldor)", elements = {
                { kind = "do", quest = 10194, title = "Stealth Flight",
                  coords = { map = 1953, x = 45.0, y = 84.0 }, note = "Flyv rekognoscering over manaforge Coruu." },
        }},
        { label = "Manaforge-nedlukningen (Consortium/Aldor)", elements = {
                { kind = "turnin", quest = 10194, title = "Stealth Flight",
                  coords = { map = 1953, x = 33.8, y = 64.2 }, note = "Aflever hos Veronia." },
        }},
        { label = "Kirin'Var Village", elements = {
                { kind = "travel", coords = { map = 1953, x = 57.5, y = 86.3 }, radius = 60,
                  text = "Kirin'Var Village", note = "Spøgelseslandsbyen i sydøst - Archmage Vargoths tårn." },
        }},
        { label = "Kirin'Var Village", elements = {
                { kind = "accept", quest = 10184, title = "Malevolent Remnants",
                  coords = { map = 1953, x = 57.5, y = 86.3 }, note = "Fra Custodian Dieworth." },
                { kind = "accept", quest = 10343, title = "The Unending Invasion",
                  coords = { map = 1953, x = 57.6, y = 86.3 }, note = "Fra Lieutenant-Sorcerer Morran." },
        }},
        { label = "Kirin'Var Village", elements = {
                { kind = "do", quest = 10184, title = "Malevolent Remnants",
                  coords = { map = 1953, x = 58.0, y = 82.0 }, note = "Saml malevolent remnants blandt spøgelserne." },
        }},
        { label = "Kirin'Var Village", elements = {
                { kind = "do", quest = 10343, title = "The Unending Invasion",
                  coords = { map = 1953, x = 60.0, y = 85.0 }, note = "Dræb Sunfury-belejrerne ved landsbyen." },
                { kind = "turnin", quest = 10184, title = "Malevolent Remnants",
                  coords = { map = 1953, x = 57.5, y = 86.3 }, note = "Aflever hos Custodian Dieworth." },
                { kind = "turnin", quest = 10343, title = "The Unending Invasion",
                  coords = { map = 1953, x = 57.6, y = 86.3 }, note = "Aflever hos Lieutenant-Sorcerer Morran." },
        }},
        { label = "Kirin'Var Village", elements = {
                { kind = "accept", quest = 10173, title = "The Archmage's Staff",
                  coords = { map = 1953, x = 31.4, y = 66.2 }, note = "Fra Ravandwyr - Archmage Vargoth-kæden." },
        }},
        { label = "Kirin'Var Village", elements = {
                { kind = "do", quest = 10173, title = "The Archmage's Staff",
                  coords = { map = 1953, x = 59.0, y = 87.0 }, note = "Find Vargoths stav i det ødelagte tårn." },
        }},
        { label = "Kirin'Var Village", elements = {
                { kind = "turnin", quest = 10173, title = "The Archmage's Staff",
                  coords = { map = 1953, x = 31.4, y = 66.2 }, note = "Aflever hos Ravandwyr." },
        }},
        { label = "The Stormspire og eco-domes", elements = {
                { kind = "travel", coords = { map = 1953, x = 44.1, y = 36.0 }, radius = 60,
                  text = "The Stormspire", note = "Ethereal-byen The Stormspire i nord (flight point)." },
        }},
        { label = "The Stormspire og eco-domes", elements = {
                { kind = "accept", quest = 10426, title = "Flora of the Eco-Domes",
                  coords = { map = 1953, x = 42.3, y = 32.6 }, note = "Fra Aurine Moonblaze - eco-domes." },
        }},
        { label = "The Stormspire og eco-domes", elements = {
                { kind = "accept", quest = 10290, title = "In Search of Farahlite",
                  coords = { map = 1953, x = 44.1, y = 36.0 }, note = "Fra Zuben Elgenubi." },
        }},
        { label = "The Stormspire og eco-domes", elements = {
                { kind = "do", quest = 10426, title = "Flora of the Eco-Domes",
                  coords = { map = 1953, x = 42.0, y = 32.0 }, note = "Undersøg floraen i Eco-Dome Midrealm." },
                { kind = "do", quest = 10290, title = "In Search of Farahlite",
                  coords = { map = 1953, x = 44.0, y = 34.0 }, note = "Find Farahlite-krystaller ved ruinerne." },
                { kind = "turnin", quest = 10426, title = "Flora of the Eco-Domes",
                  coords = { map = 1953, x = 42.3, y = 32.6 }, note = "Aflever hos Aurine Moonblaze." },
        }},
        { label = "The Stormspire og eco-domes", elements = {
                { kind = "turnin", quest = 10290, title = "In Search of Farahlite",
                  coords = { map = 1953, x = 44.1, y = 36.0 }, note = "Aflever hos Zuben Elgenubi." },
        }},
        { label = "Afslutning", elements = {
                { kind = "note", coords = { map = 1953, x = 32.0, y = 64.1 }, text = "Manaforge-kæden fortsætter",
                  note = "Consortium-kæden fortsætter: Coruu (10330) -> Duro (10338) -> Ara (10365). God XP og fører mod Voren'thal/Scryers-ry. Tryk 'Spring over', når du er klar." },
        }},
        { label = "Afslutning", elements = {
                { kind = "ding", level = 69 },
        }},
        { label = "Afslutning", elements = {
                { kind = "note", coords = { map = 1953, x = 32.7, y = 65.0 }, text = "Ryd op i Netherstorm",
                  note = "Valgfrit: ryd resterende quests (Protectorate ved Celestial Ridge, Ruins of Enkaat) indtil ca. level 69." },
        }},
        { label = "Afslutning", elements = {
                { kind = "travel", coords = { map = 1948, x = 30.0, y = 27.7 }, radius = 100,
                  text = "Mod Shadowmoon Valley", note = "Flyv til Shadowmoon Village i Shadowmoon Valley - sidste stop før level 70. Qeasy skifter automatisk rute." },
        }},
    },
})
