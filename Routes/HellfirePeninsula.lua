local _, ns = ...

-- =========================================================================
-- Hellfire Peninsula (Horde) - level 58-63
--
-- Rækkefølgen følger Wowheads "Hellfire Peninsula Horde Leveling Quest
-- Guide" for Burning Crusade Classic. Quest-id'er og koordinater er
-- best-effort: mangler et id (nil), matcher addonet på quest-titlen og
-- lærer selv id'et, når questen accepteres i spillet.
--
-- Koordinater er zone-procenter (x, y) på uiMapID:
--   1419 = Blasted Lands, 1944 = Hellfire Peninsula
-- =========================================================================

local BLASTED = 1419
local HFP = 1944

ns.Q:RegisterRoute({
    key = "hellfire-horde",
    title = "Hellfire Peninsula (Horde)",
    faction = "Horde",
    levels = "58-63",
    zones = { HFP, BLASTED },
    next = "zangarmarsh-horde",
    steps = {
        -- ============================== Ankomst ==============================
        { type = "TRAVEL", label = "Dark Portal, Blasted Lands",
          coords = { map = BLASTED, x = 55.0, y = 54.0 }, radius = 80,
          note = "Rejs til Dark Portal i Blasted Lands (portal fra Orgrimmar ved Warchief's Command Board, eller zeppelin til Grom'gol og løb/rid nordøst)." },

        { type = "ACCEPT", quest = 10121, title = "Through the Dark Portal",
          coords = { map = BLASTED, x = 55.2, y = 53.7 },
          note = "Warlord Dar'toon står ved foden af portalen. Gå derefter igennem Dark Portal." },

        { type = "TURNIN", quest = 10121, title = "Through the Dark Portal",
          coords = { map = HFP, x = 87.3, y = 52.0 }, label = "The Stair of Destiny",
          note = "Aflever hos Lieutenant General Orion på Outland-siden af portalen." },

        { type = "ACCEPT", quest = 10289, title = "Arrival in Outland",
          coords = { map = HFP, x = 87.3, y = 52.0 } },

        { type = "TURNIN", quest = 10289, title = "Arrival in Outland",
          coords = { map = HFP, x = 87.4, y = 52.2 },
          note = "Aflever hos flight masteren Vlagga Freyfeather få meter derfra." },

        { type = "ACCEPT", quest = 10120, title = "Journey to Thrallmar",
          coords = { map = HFP, x = 87.4, y = 52.2 },
          note = "Tag derefter den gratis wyvern-flyvning til Thrallmar." },

        { type = "TRAVEL", label = "Thrallmar",
          coords = { map = HFP, x = 55.3, y = 36.5 }, radius = 60,
          note = "Flyv til Thrallmar - din base i Hellfire Peninsula." },

        { type = "TURNIN", quest = 10120, title = "Journey to Thrallmar",
          coords = { map = HFP, x = 55.3, y = 36.5 },
          note = "Aflever hos General Krakork midt i Thrallmar." },

        { type = "ACCEPT", quest = 10123, title = "Report to Nazgrel",
          coords = { map = HFP, x = 55.3, y = 36.5 } },

        { type = "TURNIN", quest = 10123, title = "Report to Nazgrel",
          coords = { map = HFP, x = 55.0, y = 36.0 },
          note = "Nazgrel står inde i hovedbygningen." },

        -- ====================== Thrallmar: saml quests ======================
        { type = "ACCEPT", quest = 10124, title = "Eradicate the Burning Legion",
          coords = { map = HFP, x = 55.0, y = 36.0 },
          note = "Fra Nazgrel." },

        { type = "ACCEPT", title = "Bonechewer Blood",
          coords = { map = HFP, x = 56.3, y = 36.4 },
          note = "Fra Rohok ved essen i Thrallmar." },

        { type = "ACCEPT", title = "A Burden of Souls",
          coords = { map = HFP, x = 55.7, y = 38.2 },
          note = "Fra Apothecary Antonivich i Thrallmar." },

        -- ========================= Felspark Ravine ==========================
        { type = "DO", quest = 10124, title = "Eradicate the Burning Legion",
          coords = { map = HFP, x = 59.5, y = 28.5 }, label = "Felspark Ravine",
          note = "Dræb Flamewaker Imps og Infernal Warbringers i Felspark Ravine nordøst for Thrallmar." },

        { type = "TURNIN", quest = 10124, title = "Eradicate the Burning Legion",
          coords = { map = HFP, x = 55.0, y = 36.0 },
          note = "Tilbage til Nazgrel." },

        { type = "ACCEPT", quest = 10125, title = "Felspark Ravine",
          coords = { map = HFP, x = 55.0, y = 36.0 } },

        { type = "DO", quest = 10125, title = "Felspark Ravine",
          coords = { map = HFP, x = 60.0, y = 27.5 }, label = "Felspark Ravine",
          note = "Dræb dæmonerne ved portalerne øverst i Felspark Ravine." },

        { type = "TURNIN", quest = 10125, title = "Felspark Ravine",
          coords = { map = HFP, x = 55.0, y = 36.0 } },

        { type = "ACCEPT", quest = 10126, title = "Forward Base: Reaver's Fall",
          coords = { map = HFP, x = 55.0, y = 36.0 },
          note = "Fra Nazgrel. Vent med at løbe derud - vi tager Bonechewer-området først." },

        -- ================== Bonechewer-orcs syd for Thrallmar ===============
        { type = "DO", title = "Bonechewer Blood",
          coords = { map = HFP, x = 57.5, y = 45.5 }, label = "Bonechewer-lejre",
          note = "Dræb Bonechewer fel orcs syd for Thrallmar og saml deres blod." },

        { type = "DO", title = "A Burden of Souls",
          coords = { map = HFP, x = 57.5, y = 45.5 }, label = "Bonechewer-lejre",
          note = "Klar i samme område som Bonechewer Blood." },

        { type = "TURNIN", title = "Bonechewer Blood",
          coords = { map = HFP, x = 56.3, y = 36.4 },
          note = "Tilbage i Thrallmar: aflever hos Rohok." },

        { type = "TURNIN", title = "A Burden of Souls",
          coords = { map = HFP, x = 55.7, y = 38.2 },
          note = "Aflever hos Apothecary Antonivich." },

        { type = "ACCEPT", quest = 10838, title = "The Demoniac Scryer",
          coords = { map = HFP, x = 55.7, y = 38.2 },
          note = "Opfølger fra Apothecary Antonivich." },

        { type = "DO", quest = 10838, title = "The Demoniac Scryer",
          coords = { map = HFP, x = 44.0, y = 35.5 }, label = "Pools of Aggonar",
          note = "Placér Demoniac Scryer blandt dæmonerne vest for Thrallmar, forsvar den til den er færdig, og saml den op igen." },

        { type = "TURNIN", quest = 10838, title = "The Demoniac Scryer",
          coords = { map = HFP, x = 55.7, y = 38.2 } },

        -- ==================== Reaver's Fall og bombeture =====================
        { type = "TURNIN", quest = 10126, title = "Forward Base: Reaver's Fall",
          coords = { map = HFP, x = 69.8, y = 36.8 }, label = "Reaver's Fall",
          note = "Løb østpå ad vejen mod Dark Portal til den lille forpost Reaver's Fall." },

        { type = "ACCEPT", quest = 10146, title = "Mission: Gateways Murketh and Shaadraz",
          coords = { map = HFP, x = 69.8, y = 36.8 },
          note = "Fra Wing Commander Brack." },

        { type = "DO", quest = 10146, title = "Mission: Gateways Murketh and Shaadraz",
          coords = { map = HFP, x = 69.8, y = 36.8 }, label = "Bombetur (wyvern)",
          note = "Tal med wyvern-føreren og bomb de to gateways over Path of Glory med Seaforium-bomberne. Du flyves automatisk." },

        { type = "TURNIN", quest = 10146, title = "Mission: Gateways Murketh and Shaadraz",
          coords = { map = HFP, x = 69.8, y = 36.8 } },

        { type = "ACCEPT", title = "Mission: The Abyssal Shelf",
          coords = { map = HFP, x = 69.8, y = 36.8 },
          note = "Endnu en bombetur fra Wing Commander Brack." },

        { type = "DO", title = "Mission: The Abyssal Shelf",
          coords = { map = HFP, x = 69.8, y = 36.8 }, label = "Bombetur (wyvern)",
          note = "Kast bomber mod Gan'arg-arbejdere, Mo'arg Overseers og fel cannons på Abyssal Shelf." },

        { type = "TURNIN", title = "Mission: The Abyssal Shelf",
          coords = { map = HFP, x = 69.8, y = 36.8 } },

        -- ================== Spinebreaker Post og Zeth'Gor ====================
        { type = "TRAVEL", label = "Spinebreaker Post",
          coords = { map = HFP, x = 60.2, y = 61.0 }, radius = 60,
          note = "Løb sydvest til Spinebreaker Post og hent flight point'et." },

        { type = "ACCEPT", title = "Boiling Blood",
          coords = { map = HFP, x = 60.2, y = 61.0 },
          note = "Saml quests op ved Spinebreaker Post." },

        { type = "ACCEPT", quest = 10813, title = "The Eyes of Grillok",
          coords = { map = HFP, x = 60.2, y = 61.0 },
          note = "Fra Zezzak ved Spinebreaker Post." },

        { type = "DO", title = "Boiling Blood",
          coords = { map = HFP, x = 66.5, y = 68.0 }, label = "Zeth'Gor",
          note = "Dræb Bleeding Hollow fel orcs ved Zeth'Gor og saml deres blod." },

        { type = "DO", quest = 10813, title = "The Eyes of Grillok",
          coords = { map = HFP, x = 65.5, y = 66.5 }, label = "Zeth'Gor",
          note = "Brug Zezzak's Shard på et Eye of Grillok (svævende øjne i Zeth'Gor)." },

        { type = "TURNIN", quest = 10813, title = "The Eyes of Grillok",
          coords = { map = HFP, x = 60.2, y = 61.0 } },

        { type = "ACCEPT", quest = 10814, title = "Grillok \"Darkeye\"",
          coords = { map = HFP, x = 60.2, y = 61.0 } },

        { type = "DO", quest = 10814, title = "Grillok \"Darkeye\"",
          coords = { map = HFP, x = 68.5, y = 63.5 }, label = "Zeth'Gor",
          note = "Dræb Grillok \"Darkeye\" i den nordøstlige del af Zeth'Gor." },

        { type = "TURNIN", quest = 10814, title = "Grillok \"Darkeye\"",
          coords = { map = HFP, x = 60.2, y = 61.0 } },

        { type = "TURNIN", title = "Boiling Blood",
          coords = { map = HFP, x = 60.2, y = 61.0 } },

        -- ======================== Vestpå: Falcon Watch =======================
        { type = "TRAVEL", label = "Falcon Watch",
          coords = { map = HFP, x = 26.6, y = 60.0 }, radius = 60,
          note = "Følg vejen vestpå til blood elf-forposten Falcon Watch og hent flight point'et." },

        { type = "ACCEPT", title = "Helboar, the Other White Meat",
          coords = { map = HFP, x = 26.5, y = 59.5 },
          note = "Fra Apothecary Zelana i Falcon Watch." },

        { type = "DO", title = "Helboar, the Other White Meat",
          coords = { map = HFP, x = 30.0, y = 63.0 }, label = "Helboars",
          note = "Dræb Deranged Helboars omkring Falcon Watch og saml Tainted Helboar Meat." },

        { type = "TURNIN", title = "Helboar, the Other White Meat",
          coords = { map = HFP, x = 26.5, y = 59.5 } },

        -- ======================== Ruins of Sha'naar =========================
        { type = "TRAVEL", label = "Ruins of Sha'naar",
          coords = { map = HFP, x = 17.0, y = 52.0 }, radius = 60,
          note = "Sydvest for Falcon Watch ligger Ruins of Sha'naar med dreghood-slaverne." },

        { type = "ACCEPT", title = "Naladu",
          coords = { map = HFP, x = 17.3, y = 51.8 },
          note = "Quest-kæden starter hos dreghood'erne i ruinerne." },

        { type = "NOTE", label = "Dreghood-kæden i Sha'naar",
          coords = { map = HFP, x = 16.5, y = 52.5 },
          note = "Følg kæden: Naladu -> A Traitor Among Us -> The Dreghood Elders -> Arzeth's Demise (dræb Arzeth med staven du får). Tryk 'Spring over', når kæden er afleveret." },

        -- ============================ Afslutning =============================
        { type = "NOTE", label = "Ryd op i Hellfire", optional = true,
          coords = { map = HFP, x = 55.3, y = 36.5 },
          note = "Valgfrit: Ryd op i resterende quests i loggen (fx Void Ridge, Expedition Armory og PvP-tårnene) indtil ca. level 62. Tryk 'Spring over', når du er klar." },

        { type = "TRAVEL", label = "Mod Zangarmarsh",
          coords = { map = HFP, x = 12.0, y = 48.0 }, radius = 80,
          note = "Følg vejen vest ud af Hellfire Peninsula. Qeasy skifter automatisk til Zangarmarsh-ruten." },
    },
})
