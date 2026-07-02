local _, ns = ...

-- =========================================================================
-- Netherstorm (Horde/neutral) - level 67-69
--
-- Rækkefølgen følger Wowheads "Netherstorm Leveling Quest Guide" for
-- Burning Crusade Classic. Quest-id'er og koordinater er best-effort:
-- mangler et id (nil), matcher addonet på quest-titlen og lærer selv
-- id'et, når questen accepteres i spillet.
--
-- Koordinater er zone-procenter (x, y) på uiMapID 1953 = Netherstorm.
-- =========================================================================

local NS = 1953
local SMV = 1948

ns.Q:RegisterRoute({
    key = "netherstorm-horde",
    title = "Netherstorm (Horde)",
    faction = "Horde",
    levels = "67-69",
    zones = { NS },
    next = "shadowmoon-horde",
    steps = {
        -- ============================= Area 52 ===============================
        { type = "TRAVEL", label = "Area 52",
          coords = { map = NS, x = 32.5, y = 64.0 }, radius = 60,
          note = "Goblin-byen Area 52 er din base i Netherstorm (flight point). Overvej at binde din hearthstone her." },

        { type = "ACCEPT", title = "You're Hired!",
          coords = { map = NS, x = 32.5, y = 64.0 },
          note = "Goblinerne ved indgangen hyrer dig på stedet." },

        { type = "DO", title = "You're Hired!",
          coords = { map = NS, x = 23.0, y = 69.0 }, label = "Manaforge B'naar",
          note = "Løs opgaven ved Manaforge B'naar sydvest for Area 52." },

        { type = "TURNIN", title = "You're Hired!",
          coords = { map = NS, x = 32.5, y = 64.0 } },

        { type = "NOTE", label = "Area 52-quests",
          coords = { map = NS, x = 32.5, y = 64.0 },
          note = "Saml resten af Area 52-questsene op - de peger mod manaforge'ene, Sunfury-elverne og ødemarkerne. Tryk 'Spring over', når loggen er fyldt." },

        -- ==================== Manaforge-nedlukningskæden =====================
        { type = "NOTE", label = "Shutting Down Manaforge B'naar",
          coords = { map = NS, x = 23.0, y = 69.0 },
          note = "Consortium-kæden 'Shutting Down Manaforge...': brug adgangs-nøglen på konsollen i Manaforge B'naar (vagterne omkring konsollen skal ryddes). Tryk 'Spring over', når B'naar er lukket ned." },

        { type = "NOTE", label = "Shutting Down Manaforge Coruu",
          coords = { map = NS, x = 49.0, y = 84.0 },
          note = "Samme procedure ved Manaforge Coruu mod sydøst. Tryk 'Spring over', når den er lukket ned." },

        { type = "NOTE", label = "Shutting Down Manaforge Duro",
          coords = { map = NS, x = 57.0, y = 64.0 },
          note = "Videre til Manaforge Duro mod øst. Tryk 'Spring over', når den er lukket ned." },

        { type = "NOTE", label = "Shutting Down Manaforge Ara", optional = true,
          coords = { map = NS, x = 22.0, y = 55.0 },
          note = "Kædens finale ved Manaforge Ara i nordvest - hårdere område. Tryk 'Spring over', når den er klaret (eller hvis du springer den over)." },

        -- ========================= Kirin'Var Village =========================
        { type = "NOTE", label = "Kirin'Var Village (Archmage Vargoth)",
          coords = { map = NS, x = 57.0, y = 85.0 },
          note = "Spøgelseslandsbyen Kirin'Var i sydøst: Archmage Vargoth i troldmandstårnet har en fin quest-kæde om landsbyens skæbne. Tryk 'Spring over', når du er færdig." },

        -- ==================== The Stormspire og eco-domes ====================
        { type = "TRAVEL", label = "The Stormspire",
          coords = { map = NS, x = 45.0, y = 36.0 }, radius = 60,
          note = "Ethereal-byen The Stormspire i nord (flight point)." },

        { type = "NOTE", label = "Stormspire- og eco-dome-quests",
          coords = { map = NS, x = 47.0, y = 52.0 },
          note = "Løs Consortium- og Protectorate-questsene i og omkring eco-dome-kuplerne (Eco-Dome Midrealm m.fl.). Tryk 'Spring over', når du er færdig." },

        { type = "NOTE", label = "Cosmowrench", optional = true,
          coords = { map = NS, x = 65.0, y = 32.0 },
          note = "Valgfrit: Cosmowrench mod øst ved Tempest Keep har et par quests og flight point - praktisk hvis du senere skal i heroics/raids her. Tryk 'Spring over'." },

        -- ============================ Afslutning =============================
        { type = "NOTE", label = "Ryd op i Netherstorm", optional = true,
          coords = { map = NS, x = 32.5, y = 64.0 },
          note = "Valgfrit: Ryd op i resterende quests indtil ca. level 69. Tryk 'Spring over', når du er klar." },

        { type = "TRAVEL", label = "Mod Shadowmoon Valley",
          coords = { map = SMV, x = 30.0, y = 28.0 }, radius = 100,
          note = "Flyv til Shadowmoon Village i Shadowmoon Valley - sidste stop før level 70. Qeasy skifter automatisk rute." },
    },
})
