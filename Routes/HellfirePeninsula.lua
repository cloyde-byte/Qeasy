local _, ns = ...

-- =========================================================================
-- Hellfire Peninsula (Horde) - level 58-63
--
-- Rækkefølgen følger Wowheads leveling-guide for Burning Crusade Classic.
-- Quest-id'er og koordinater er verificeret mod pfQuest-databasen
-- (https://github.com/shagu/pfQuest, MIT-licens, © Eric Mauser/Shagu).
-- Ruten er GENERERET af tools/plans.py - rediger ikke i hånden.
--
-- Format: grupperede steps med elementer (kind = accept|do|turnin|travel|
-- fly|hearth|train|vendor|buy|note|ding|grind). Koordinater er zone-
-- procenter (x, y) på uiMapID:
--   1419 = Blasted Lands, 1944 = Hellfire Peninsula, 1946 = Zangarmarsh
-- =========================================================================

ns.Q:RegisterRoute({
    key = "hellfire-horde",
    title = "Hellfire Peninsula (Horde)",
    faction = "Horde",
    levels = "58-63",
    zones = { 1944, 1419 },
    next = "zangarmarsh-horde",
    steps = {
        { label = "Gennem Dark Portal", elements = {
                { kind = "travel", coords = { map = 1419, x = 55.2, y = 53.7 }, radius = 90,
                  text = "Dark Portal, Blasted Lands", note = "Rejs til Dark Portal i Blasted Lands (portal fra Orgrimmar, eller zeppelin til Grom'gol og løb nordøst)." },
        }},
        { label = "Gennem Dark Portal", elements = {
                { kind = "accept", quest = 9407, title = "Through the Dark Portal",
                  coords = { map = 1419, x = 58.1, y = 56.0 }, note = "Warlord Dar'toon står ved foden af portalen. Gå derefter gennem Dark Portal." },
        }},
        { label = "Gennem Dark Portal", elements = {
                { kind = "turnin", quest = 9407, title = "Through the Dark Portal",
                  coords = { map = 1944, x = 87.4, y = 49.8 }, note = "Aflever hos Lieutenant General Orion på Outland-siden." },
                { kind = "accept", quest = 10120, title = "Arrival in Outland",
                  coords = { map = 1944, x = 87.4, y = 49.8 }, note = "Fra Lieutenant General Orion." },
                { kind = "turnin", quest = 10120, title = "Arrival in Outland",
                  coords = { map = 1944, x = 87.3, y = 48.1 }, note = "Aflever hos flight masteren Vlagga Freyfeather. Tag derefter den gratis wyvern til Thrallmar." },
                { kind = "accept", quest = 10289, title = "Journey to Thrallmar",
                  coords = { map = 1944, x = 87.3, y = 48.1 }, note = "Fra Vlagga Freyfeather." },
        }},
        { label = "Gennem Dark Portal", elements = {
                { kind = "travel", coords = { map = 1944, x = 55.3, y = 36.5 }, radius = 60,
                  text = "Thrallmar", note = "Flyv til Thrallmar - din base i Hellfire Peninsula." },
        }},
        { label = "Gennem Dark Portal", elements = {
                { kind = "turnin", quest = 10289, title = "Journey to Thrallmar",
                  coords = { map = 1944, x = 55.9, y = 36.7 }, note = "Aflever hos General Krakork midt i Thrallmar." },
                { kind = "accept", quest = 10291, title = "Report to Nazgrel",
                  coords = { map = 1944, x = 55.9, y = 36.7 }, note = "Fra General Krakork." },
                { kind = "turnin", quest = 10291, title = "Report to Nazgrel",
                  coords = { map = 1944, x = 55.0, y = 36.0 }, note = "Nazgrel står inde i hovedbygningen bag Krakork." },
        }},
        { label = "Gennem Dark Portal", elements = {
                { kind = "train", coords = { map = 1944, x = 55.3, y = 36.5 }, text = "Træn dine nye spells hos klassetræneren i Thrallmar." },
        }},
        { label = "Gennem Dark Portal", elements = {
                { kind = "hearth", coords = { map = 1944, x = 55.3, y = 36.5 }, text = "Sæt din hearthstone i Thrallmar" },
        }},
        { label = "Thrallmar: saml op og ryd ramparts", elements = {
                { kind = "accept", quest = 10110, title = "Hellfire Fortifications",
                  coords = { map = 1944, x = 56.0, y = 39.2 }, note = "Fra Battlecryer Blackeye - dræb fel orcs på Hellfire Ramparts." },
                { kind = "accept", quest = 10086, title = "I Work... For the Horde!",
                  coords = { map = 1944, x = 55.2, y = 38.8 }, note = "Fra goblinen Megzeg Nukklebust." },
                { kind = "accept", quest = 10087, title = "Burn It Up... For the Horde!",
                  coords = { map = 1944, x = 55.2, y = 38.8 }, note = "Fra Megzeg Nukklebust." },
                { kind = "accept", quest = 10450, title = "Bonechewer Blood",
                  coords = { map = 1944, x = 55.1, y = 36.4 }, note = "Fra Vurtok Axebreaker ved essen." },
                { kind = "accept", quest = 10121, title = "Eradicate the Burning Legion",
                  coords = { map = 1944, x = 55.0, y = 36.0 }, note = "Fra Nazgrel." },
        }},
        { label = "Thrallmar: saml op og ryd ramparts", elements = {
                { kind = "do", quest = 10110, title = "Hellfire Fortifications",
                  coords = { map = 1944, x = 51.0, y = 32.0 }, note = "Dræb Hellfire-fel orcs på ramparts nord for Thrallmar." },
        }},
        { label = "Thrallmar: saml op og ryd ramparts", elements = {
                { kind = "do", quest = 10086, title = "I Work... For the Horde!",
                  coords = { map = 1944, x = 59.0, y = 30.0 }, note = "Saml fuel og tryk på pumperne ved Legion Front nordøst for Thrallmar." },
        }},
        { label = "Thrallmar: saml op og ryd ramparts", elements = {
                { kind = "turnin", quest = 10086, title = "I Work... For the Horde!",
                  coords = { map = 1944, x = 55.2, y = 38.8 }, note = "Aflever hos Megzeg Nukklebust." },
                { kind = "turnin", quest = 10087, title = "Burn It Up... For the Horde!",
                  coords = { map = 1944, x = 55.2, y = 38.8 }, note = "Tilbage til Megzeg." },
        }},
        { label = "Thrallmar: saml op og ryd ramparts", elements = {
                { kind = "do", quest = 10450, title = "Bonechewer Blood",
                  coords = { map = 1944, x = 44.0, y = 40.0 }, note = "Dræb Bonechewer fel orcs syd/vest for Thrallmar og saml blod." },
        }},
        { label = "Thrallmar: saml op og ryd ramparts", elements = {
                { kind = "turnin", quest = 10450, title = "Bonechewer Blood",
                  coords = { map = 1944, x = 55.1, y = 36.4 }, note = "Aflever hos Vurtok Axebreaker." },
                { kind = "accept", quest = 10449, title = "Apothecary Zelana",
                  coords = { map = 1944, x = 55.1, y = 36.4 }, note = "Opfølger fra Vurtok." },
                { kind = "turnin", quest = 10110, title = "Hellfire Fortifications",
                  coords = { map = 1944, x = 56.0, y = 39.2 }, note = "Tilbage til Battlecryer Blackeye." },
        }},
        { label = "Thrallmar: saml op og ryd ramparts", elements = {
                { kind = "do", quest = 10121, title = "Eradicate the Burning Legion",
                  coords = { map = 1944, x = 47.0, y = 36.0 }, note = "Dræb Flamewaker Imps og Infernals i Pools of Aggonar (dæmon-portalen sydvest for Thrallmar)." },
        }},
        { label = "Thrallmar: saml op og ryd ramparts", elements = {
                { kind = "turnin", quest = 10121, title = "Eradicate the Burning Legion",
                  coords = { map = 1944, x = 58.1, y = 41.3 }, note = "Aflever hos Sergeant Shatterskull ved Temple of Telhamat-vejen." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "accept", quest = 10123, title = "Felspark Ravine",
                  coords = { map = 1944, x = 58.1, y = 41.3 }, note = "Fra Sergeant Shatterskull." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "do", quest = 10123, title = "Felspark Ravine",
                  coords = { map = 1944, x = 60.0, y = 28.0 }, note = "Ryd Felspark Ravine nordøst for Thrallmar for Legion-dæmoner." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "turnin", quest = 10123, title = "Felspark Ravine",
                  coords = { map = 1944, x = 58.1, y = 41.3 }, note = "Aflever hos Sergeant Shatterskull." },
                { kind = "accept", quest = 10124, title = "Forward Base: Reaver's Fall",
                  coords = { map = 1944, x = 58.1, y = 41.3 }, note = "Fra Sergeant Shatterskull." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "travel", coords = { map = 1944, x = 65.9, y = 43.6 }, radius = 60,
                  text = "Reaver's Fall", note = "Løb sydøst ad vejen mod Dark Portal til forposten Reaver's Fall." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "turnin", quest = 10124, title = "Forward Base: Reaver's Fall",
                  coords = { map = 1944, x = 65.9, y = 43.6 }, note = "Aflever hos Forward Commander To'arch." },
                { kind = "accept", quest = 10208, title = "Disrupt Their Reinforcements",
                  coords = { map = 1944, x = 65.9, y = 43.6 }, note = "Fra Forward Commander To'arch." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "do", quest = 10208, title = "Disrupt Their Reinforcements",
                  coords = { map = 1944, x = 60.0, y = 45.0 }, note = "Dræb Legion-styrker langs Path of Glory (vejen af knogler)." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "turnin", quest = 10208, title = "Disrupt Their Reinforcements",
                  coords = { map = 1944, x = 65.9, y = 43.6 }, note = "Aflever hos Forward Commander To'arch." },
                { kind = "accept", quest = 10129, title = "Mission: Gateways Murketh and Shaadraz",
                  coords = { map = 1944, x = 65.9, y = 43.6 }, note = "Bombetur - tal med wyvern-føreren." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "do", quest = 10129, title = "Mission: Gateways Murketh and Shaadraz",
                  coords = { map = 1944, x = 63.0, y = 55.0 }, note = "Bomb gateways Murketh og Shaadraz over Path of Glory. Du flyves automatisk." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "turnin", quest = 10129, title = "Mission: Gateways Murketh and Shaadraz",
                  coords = { map = 1944, x = 65.9, y = 43.6 }, note = "Aflever hos Forward Commander To'arch." },
                { kind = "accept", quest = 10162, title = "Mission: The Abyssal Shelf",
                  coords = { map = 1944, x = 65.9, y = 43.6 }, note = "Fra Forward Commander To'arch." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "do", quest = 10162, title = "Mission: The Abyssal Shelf",
                  coords = { map = 1944, x = 66.0, y = 60.0 }, note = "Bomb Gan'arg-arbejdere og fel cannons på Abyssal Shelf." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "turnin", quest = 10162, title = "Mission: The Abyssal Shelf",
                  coords = { map = 1944, x = 65.9, y = 43.6 }, note = "Aflever hos Forward Commander To'arch." },
                { kind = "accept", quest = 10388, title = "Return to Thrallmar",
                  coords = { map = 1944, x = 65.9, y = 43.6 }, note = "Fra Forward Commander To'arch." },
        }},
        { label = "Legion-fronten: Reaver's Fall", elements = {
                { kind = "turnin", quest = 10388, title = "Return to Thrallmar",
                  coords = { map = 1944, x = 55.0, y = 36.0 }, note = "Tilbage til Nazgrel i Thrallmar." },
        }},
        { label = "Nazgrels Legion-kæde", elements = {
                { kind = "accept", quest = 10390, title = "Forge Camp: Mageddon",
                  coords = { map = 1944, x = 55.0, y = 36.0 }, note = "Fra Nazgrel." },
        }},
        { label = "Nazgrels Legion-kæde", elements = {
                { kind = "do", quest = 10390, title = "Forge Camp: Mageddon",
                  coords = { map = 1944, x = 44.0, y = 32.0 }, note = "Dræb Forge Camp: Mageddon-dæmonerne (og infernalen Gorehowl) vest for Thrallmar." },
        }},
        { label = "Nazgrels Legion-kæde", elements = {
                { kind = "turnin", quest = 10390, title = "Forge Camp: Mageddon",
                  coords = { map = 1944, x = 55.0, y = 36.0 }, note = "Aflever hos Nazgrel." },
                { kind = "accept", quest = 10391, title = "Cannons of Rage",
                  coords = { map = 1944, x = 55.0, y = 36.0 }, note = "Fra Nazgrel." },
        }},
        { label = "Nazgrels Legion-kæde", elements = {
                { kind = "do", quest = 10391, title = "Cannons of Rage",
                  coords = { map = 1944, x = 49.0, y = 24.0 }, note = "Ødelæg fel cannons ved Forge Camp: Rage nord for Thrallmar." },
        }},
        { label = "Nazgrels Legion-kæde", elements = {
                { kind = "turnin", quest = 10391, title = "Cannons of Rage",
                  coords = { map = 1944, x = 55.0, y = 36.0 }, note = "Aflever hos Nazgrel." },
                { kind = "accept", quest = 10392, title = "Doorway to the Abyss",
                  coords = { map = 1944, x = 55.0, y = 36.0 }, note = "Fra Nazgrel." },
        }},
        { label = "Nazgrels Legion-kæde", elements = {
                { kind = "do", quest = 10392, title = "Doorway to the Abyss",
                  coords = { map = 1944, x = 49.0, y = 24.0 }, note = "Luk portalen ved Forge Camp: Rage." },
        }},
        { label = "Nazgrels Legion-kæde", elements = {
                { kind = "turnin", quest = 10392, title = "Doorway to the Abyss",
                  coords = { map = 1944, x = 55.0, y = 36.0 }, note = "Aflever hos Nazgrel." },
        }},
        { label = "Spinebreaker Post og Zeth'Gor", elements = {
                { kind = "accept", quest = 10449, title = "Apothecary Zelana",
                  coords = { map = 1944, x = 55.1, y = 36.4 }, note = "Fra Vurtok Axebreaker.", optional = true },
        }},
        { label = "Spinebreaker Post og Zeth'Gor", elements = {
                { kind = "travel", coords = { map = 1944, x = 61.1, y = 81.8 }, radius = 60,
                  text = "Spinebreaker Post", note = "Løb syd til Spinebreaker Post og hent flight point'et." },
        }},
        { label = "Spinebreaker Post og Zeth'Gor", elements = {
                { kind = "turnin", quest = 10449, title = "Apothecary Zelana",
                  coords = { map = 1944, x = 66.2, y = 42.0 }, note = "Aflever hos Apothecary Zelana... (bemærk: Zelana er ved ramparts - se note)." },
                { kind = "accept", quest = 10242, title = "Spinebreaker Post",
                  coords = { map = 1944, x = 66.2, y = 42.0 }, note = "Fra Apothecary Zelana." },
        }},
        { label = "Spinebreaker Post og Zeth'Gor", elements = {
                { kind = "turnin", quest = 10242, title = "Spinebreaker Post",
                  coords = { map = 1944, x = 61.1, y = 81.8 }, note = "Aflever hos Apothecary Albreck ved Spinebreaker Post." },
                { kind = "accept", quest = 10538, title = "Boiling Blood",
                  coords = { map = 1944, x = 61.1, y = 81.8 }, note = "Fra Apothecary Albreck." },
                { kind = "accept", quest = 10809, title = "Wanted: Worg Master Kruush",
                  coords = { map = 1944, x = 61.2, y = 80.6 }, note = "Wanted-plakat ved Spinebreaker Post." },
        }},
        { label = "Spinebreaker Post og Zeth'Gor", elements = {
                { kind = "do", quest = 10538, title = "Boiling Blood",
                  coords = { map = 1944, x = 66.5, y = 68.0 }, note = "Dræb Bleeding Hollow fel orcs ved Zeth'Gor øst for posten og saml blod." },
        }},
        { label = "Spinebreaker Post og Zeth'Gor", elements = {
                { kind = "turnin", quest = 10538, title = "Boiling Blood",
                  coords = { map = 1944, x = 61.1, y = 81.8 }, note = "Aflever hos Apothecary Albreck." },
                { kind = "accept", quest = 10813, title = "The Eyes of Grillok",
                  coords = { map = 1944, x = 61.7, y = 81.9 }, note = "Fra Zezzak." },
        }},
        { label = "Spinebreaker Post og Zeth'Gor", elements = {
                { kind = "do", quest = 10813, title = "The Eyes of Grillok",
                  coords = { map = 1944, x = 65.5, y = 66.5 }, note = "Brug Zezzak's Shard på et Eye of Grillok i Zeth'Gor." },
        }},
        { label = "Spinebreaker Post og Zeth'Gor", elements = {
                { kind = "turnin", quest = 10813, title = "The Eyes of Grillok",
                  coords = { map = 1944, x = 61.7, y = 81.9 }, note = "Aflever hos Zezzak." },
                { kind = "accept", quest = 10834, title = "Grillok \"Darkeye\"",
                  coords = { map = 1944, x = 61.7, y = 81.9 }, note = "Fra Zezzak." },
        }},
        { label = "Spinebreaker Post og Zeth'Gor", elements = {
                { kind = "do", quest = 10834, title = "Grillok \"Darkeye\"",
                  coords = { map = 1944, x = 68.5, y = 63.5 }, note = "Dræb Grillok \"Darkeye\" i den nordøstlige del af Zeth'Gor." },
        }},
        { label = "Spinebreaker Post og Zeth'Gor", elements = {
                { kind = "turnin", quest = 10834, title = "Grillok \"Darkeye\"",
                  coords = { map = 1944, x = 61.7, y = 81.9 }, note = "Aflever hos Zezzak." },
        }},
        { label = "Vestpå: Falcon Watch og Sha'naar", elements = {
                { kind = "accept", quest = 9498, title = "Falcon Watch",
                  coords = { map = 1944, x = 55.2, y = 39.1 }, note = "Fra Martik Tor'seldori i Thrallmar (rejs vestpå)." },
        }},
        { label = "Vestpå: Falcon Watch og Sha'naar", elements = {
                { kind = "travel", coords = { map = 1944, x = 28.5, y = 60.2 }, radius = 60,
                  text = "Falcon Watch", note = "Følg vejen vestpå til blood elf-forposten Falcon Watch." },
        }},
        { label = "Vestpå: Falcon Watch og Sha'naar", elements = {
                { kind = "turnin", quest = 9498, title = "Falcon Watch",
                  coords = { map = 1944, x = 28.5, y = 60.2 }, note = "Aflever hos Ranger Captain Venn'ren." },
        }},
        { label = "Vestpå: Falcon Watch og Sha'naar", elements = {
                { kind = "accept", quest = 9361, title = "Helboar, the Other White Meat",
                  coords = { map = 1944, x = 49.2, y = 74.8 }, note = "Fra Legassi ved vraget syd for Falcon Watch." },
        }},
        { label = "Vestpå: Falcon Watch og Sha'naar", elements = {
                { kind = "do", quest = 9361, title = "Helboar, the Other White Meat",
                  coords = { map = 1944, x = 45.0, y = 74.0 }, note = "Dræb Deranged Helboars og saml Tainted Helboar Meat." },
        }},
        { label = "Vestpå: Falcon Watch og Sha'naar", elements = {
                { kind = "turnin", quest = 9361, title = "Helboar, the Other White Meat",
                  coords = { map = 1944, x = 49.2, y = 74.8 }, note = "Aflever hos Legassi." },
        }},
        { label = "Vestpå: Falcon Watch og Sha'naar", elements = {
                { kind = "accept", quest = 10403, title = "Naladu",
                  coords = { map = 1944, x = 15.6, y = 58.7 }, note = "Fra Akoru the Firecaller i Ruins of Sha'naar (sydvest)." },
        }},
        { label = "Vestpå: Falcon Watch og Sha'naar", elements = {
                { kind = "travel", coords = { map = 1944, x = 16.3, y = 65.1 }, radius = 60,
                  text = "Ruins of Sha'naar", note = "Sydvest for Falcon Watch: dreghood-slaverne i Sha'naar." },
        }},
        { label = "Vestpå: Falcon Watch og Sha'naar", elements = {
                { kind = "turnin", quest = 10403, title = "Naladu",
                  coords = { map = 1944, x = 16.3, y = 65.1 }, note = "Aflever hos Naladu." },
        }},
        { label = "Vestpå: Falcon Watch og Sha'naar", elements = {
                { kind = "note", coords = { map = 1944, x = 16.3, y = 65.1 }, text = "Dreghood-kæden",
                  note = "Følg Naladus kæde: A Traitor Among Us -> The Dreghood Elders -> Arzeth's Demise. Tryk 'Spring over', når kæden er afleveret." },
        }},
        { label = "Afslutning", elements = {
                { kind = "ding", level = 62 },
        }},
        { label = "Afslutning", elements = {
                { kind = "note", coords = { map = 1944, x = 55.3, y = 36.5 }, text = "Ryd op i Hellfire",
                  note = "Valgfrit: ryd resterende quests i loggen (Void Ridge, The Mag'har-kæden, Expedition Armory) indtil ca. level 62." },
        }},
        { label = "Afslutning", elements = {
                { kind = "travel", coords = { map = 1946, x = 78.5, y = 62.7 }, radius = 100,
                  text = "Mod Zangarmarsh", note = "Følg vejen vest/nordvest ud af Hellfire mod Zangarmarsh. Qeasy skifter automatisk rute." },
        }},
    },
})
