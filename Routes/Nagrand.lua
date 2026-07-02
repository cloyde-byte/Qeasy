local _, ns = ...

-- =========================================================================
-- Nagrand (Horde) - level 64-67
--
-- Rækkefølgen følger Wowheads "Nagrand Horde Leveling Quest Guide" for
-- Burning Crusade Classic. Quest-id'er og koordinater er best-effort:
-- mangler et id (nil), matcher addonet på quest-titlen og lærer selv
-- id'et, når questen accepteres i spillet.
--
-- Koordinater er zone-procenter (x, y) på uiMapID 1951 = Nagrand.
-- =========================================================================

local NG = 1951
local BEM = 1949

ns.Q:RegisterRoute({
    key = "nagrand-horde",
    title = "Nagrand (Horde)",
    faction = "Horde",
    levels = "64-67",
    zones = { NG },
    next = "blades-edge-horde",
    steps = {
        -- ============================= Garadar ==============================
        { type = "TRAVEL", label = "Garadar",
          coords = { map = NG, x = 55.5, y = 37.5 }, radius = 60,
          note = "Følg vejen fra Terokkar ind i Nagrand og op til Mag'har-byen Garadar (flight point). Dette er din base i zonen." },

        { type = "NOTE", label = "Garadar-quests",
          coords = { map = NG, x = 55.5, y = 37.5 },
          note = "Saml alle quests op i Garadar - de peger mod elementerne, Kil'sorrow, Murkblood og Warmaul-ogrerne. Tryk 'Spring over', når loggen er fyldt." },

        { type = "NOTE", label = "Garrosh og Greatmother Geyah", optional = true,
          coords = { map = NG, x = 55.5, y = 37.5 },
          note = "Tal med Garrosh Hellscream og Greatmother Geyah i Garadar - lore-kæden her ender senere med 'Hero of the Mag'har' og et besøg af Thrall. Tryk 'Spring over', når du har startet kæden." },

        -- ====================== Throne of the Elements ======================
        { type = "TRAVEL", label = "Throne of the Elements",
          coords = { map = NG, x = 60.0, y = 22.0 }, radius = 60,
          note = "Nordøst for Garadar ligger Throne of the Elements, hvor elementernes furies holder til." },

        { type = "NOTE", label = "Element-quests",
          coords = { map = NG, x = 60.0, y = 22.0 },
          note = "Løs element-questsene herfra (jord-, vind- og vandånderne omkring søen og markerne). Tryk 'Spring over', når du er færdig." },

        -- ======================= Nesingwary Safari ==========================
        { type = "TRAVEL", label = "Nesingwary Safari",
          coords = { map = NG, x = 71.0, y = 41.0 }, radius = 60,
          note = "Hemet Nesingwarys jagtlejr i det østlige Nagrand." },

        { type = "ACCEPT", title = "Clefthoof Mastery",
          coords = { map = NG, x = 71.0, y = 41.0 },
          note = "Tag alle tre Mastery-quests: Clefthoof, Windroc og Talbuk. Hver har tre trin og giver tilsammen enorm XP, mens du alligevel bevæger dig rundt i zonen." },

        { type = "ACCEPT", title = "Windroc Mastery",
          coords = { map = NG, x = 71.0, y = 41.0 } },

        { type = "ACCEPT", title = "Talbuk Mastery",
          coords = { map = NG, x = 71.0, y = 41.0 } },

        { type = "NOTE", label = "Safari-jagt",
          coords = { map = NG, x = 63.0, y = 50.0 },
          note = "Jag clefthoofs, windrocs og talbuks på sletterne (de findes i hele Nagrand) og aflever Mastery-questsene løbende hos Nesingwary. Tryk 'Spring over', når alle tre kæder er færdige - eller fortsæt og gør dem sideløbende med resten af ruten." },

        -- ==================== Consortium: Aeris Landing =====================
        { type = "TRAVEL", label = "Aeris Landing",
          coords = { map = NG, x = 31.0, y = 57.0 }, radius = 60,
          note = "Consortium-lejren Aeris Landing i det sydvestlige Nagrand, ved foden af Oshu'gun." },

        { type = "NOTE", label = "Consortium-quests",
          coords = { map = NG, x = 31.0, y = 57.0 },
          note = "Gezhe og Consortium giver quests omkring Oshu'gun-krystallerne og ånderne på Spirit Fields - og et medlemskab med månedlige gem-poser. Tryk 'Spring over', når du er færdig i området." },

        -- ========================= Sunspring Post ===========================
        { type = "NOTE", label = "Sunspring Post (Murkblood)",
          coords = { map = NG, x = 33.0, y = 41.0 },
          note = "Murkblood-Broken har overtaget Sunspring Post. Løs Garadars quests om massakren her. Tryk 'Spring over', når du er færdig." },

        -- ========================== Warmaul Hill ============================
        { type = "NOTE", label = "Warmaul Hill",
          coords = { map = NG, x = 22.0, y = 28.0 },
          note = "Warmaul-ogrernes bakke i nordvest: løs ogre-questsene, og gå til sidst ind i grotten på toppen efter Cho'war the Pillager. Tryk 'Spring over', når du er færdig." },

        { type = "ACCEPT", title = "Wanted: Giselda the Crone", optional = true,
          coords = { map = NG, x = 55.5, y = 37.5 },
          note = "Dusør-opslag i Garadar: Giselda holder til på Warmaul Hill - tag den med, inden du rydder bakken." },

        -- ========================== Ring of Blood ===========================
        { type = "NOTE", label = "Ring of Blood (gruppe)", optional = true,
          coords = { map = NG, x = 43.0, y = 21.0 },
          note = "The Ring of Blood ved Laughing Skull Ruins: seks gladiator-kampe i træk for en 5-mands gruppe. En af de bedste XP-klumper i hele TBC plus et stærkt våben - find en gruppe i chatten! Tryk 'Spring over', hvis du springer den over." },

        -- ========================= Kil'sorrow m.m. ==========================
        { type = "NOTE", label = "Kil'sorrow Fortress", optional = true,
          coords = { map = NG, x = 56.0, y = 73.0 },
          note = "Kil'sorrow-fæstningen i sydøst: dæmontilbedende orcs - Garadar har quests mod dem. Tryk 'Spring over', når du er færdig." },

        -- ============================ Afslutning =============================
        { type = "NOTE", label = "Ryd op i Nagrand", optional = true,
          coords = { map = NG, x = 55.5, y = 37.5 },
          note = "Valgfrit: Gør Mastery-kæderne og resterende Garadar-quests færdige indtil ca. level 66-67. Tryk 'Spring over', når du er klar." },

        { type = "TRAVEL", label = "Mod Blade's Edge Mountains",
          coords = { map = BEM, x = 52.5, y = 54.5 }, radius = 100,
          note = "Flyv til Zangarmarsh og følg den nordlige vej op gennem bjergene til Thunderlord Stronghold i Blade's Edge Mountains. Qeasy skifter automatisk rute." },
    },
})
