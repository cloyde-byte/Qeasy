local _, ns = ...

-- =========================================================================
-- Blade's Edge Mountains (Horde) - level 65-68
--
-- Rækkefølgen følger Wowheads "Blade's Edge Mountains Horde Leveling
-- Quest Guide" for Burning Crusade Classic. Quest-id'er og koordinater er
-- best-effort: mangler et id (nil), matcher addonet på quest-titlen og
-- lærer selv id'et, når questen accepteres i spillet.
--
-- Koordinater er zone-procenter (x, y) på uiMapID 1949 = Blade's Edge.
-- =========================================================================

local BEM = 1949
local NS = 1953

ns.Q:RegisterRoute({
    key = "blades-edge-horde",
    title = "Blade's Edge Mountains (Horde)",
    faction = "Horde",
    levels = "65-68",
    zones = { BEM },
    next = "netherstorm-horde",
    steps = {
        -- ====================== Thunderlord Stronghold ======================
        { type = "TRAVEL", label = "Thunderlord Stronghold",
          coords = { map = BEM, x = 52.5, y = 54.5 }, radius = 60,
          note = "Horde-basen Thunderlord Stronghold midt i zonen (flight point)." },

        { type = "NOTE", label = "Thunderlord-quests",
          coords = { map = BEM, x = 52.5, y = 54.5 },
          note = "Saml alle quests op - de peger mod Bloodmaul-ogrerne, dalenes dyr og fel-orcerne. Tryk 'Spring over', når loggen er fyldt." },

        { type = "NOTE", label = "Bloodmaul-lejrene",
          coords = { map = BEM, x = 45.0, y = 60.0 },
          note = "Ryd Bloodmaul-ogrernes lejre og huler sydvest for Thunderlord Stronghold, og løs questsene i området. Tryk 'Spring over', når du er færdig." },

        -- ========================= Mok'Nathal Village ========================
        { type = "TRAVEL", label = "Mok'Nathal Village",
          coords = { map = BEM, x = 75.0, y = 60.0 }, radius = 60,
          note = "Halvogrenes landsby i sydøst (flight point). Her møder du Rexxar og hans far Leoroxx." },

        { type = "NOTE", label = "Mok'Nathal-quests",
          coords = { map = BEM, x = 75.0, y = 60.0 },
          note = "Løs Rexxars og landsbyens quests i dalene omkring byen. Tryk 'Spring over', når du er færdig." },

        -- ============================ Evergrove ==============================
        { type = "TRAVEL", label = "Evergrove",
          coords = { map = BEM, x = 62.0, y = 39.5 }, radius = 60,
          note = "Flyv/løb nordpå til druidernes lejr Evergrove (flight point)." },

        { type = "NOTE", label = "Evergrove-quests",
          coords = { map = BEM, x = 62.0, y = 39.5 },
          note = "Saml Evergrove-questsene op: de dækker Ruuan Weald, wyrmerne og dæmonerne i nord. Tryk 'Spring over', når loggen er fyldt." },

        { type = "NOTE", label = "Death's Door",
          coords = { map = BEM, x = 35.0, y = 72.0 },
          note = "Ved Death's Door i syd åbner Legionen portaler - løs questsene mod fel cannons og portalvogterne. Tryk 'Spring over', når du er færdig." },

        { type = "NOTE", label = "Gruuls sønner (Baron Sablemane)", optional = true,
          coords = { map = BEM, x = 62.0, y = 39.5 },
          note = "Baron Sablemanes kæde mod Gruuls sønner (Grulloc, Maggoc m.fl.) giver stor XP og fører op mod Gruul's Lair - enkelte dele kræver en gruppe. Tryk 'Spring over', hvis du springer den over." },

        -- ============================ Afslutning =============================
        { type = "NOTE", label = "Ryd op i Blade's Edge", optional = true,
          coords = { map = BEM, x = 52.5, y = 54.5 },
          note = "Valgfrit: Ryd op i resterende quests (Bladespire-ogrerne, arakkoa-lejrene) indtil ca. level 67-68. Tryk 'Spring over', når du er klar." },

        { type = "TRAVEL", label = "Mod Netherstorm",
          coords = { map = NS, x = 32.5, y = 64.0 }, radius = 100,
          note = "Følg vejen nordøst ud af Blade's Edge og over broen til Netherstorm. Første stop er goblin-byen Area 52. Qeasy skifter automatisk rute." },
    },
})
