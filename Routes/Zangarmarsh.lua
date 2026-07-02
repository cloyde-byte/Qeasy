local _, ns = ...

-- =========================================================================
-- Zangarmarsh (Horde) - level 61-64
--
-- Rækkefølgen følger Wowheads "Zangarmarsh Horde Leveling Quest Guide"
-- for Burning Crusade Classic. Quest-id'er og koordinater er best-effort:
-- mangler et id (nil), matcher addonet på quest-titlen og lærer selv
-- id'et, når questen accepteres i spillet.
--
-- Koordinater er zone-procenter (x, y) på uiMapID 1946 = Zangarmarsh.
-- =========================================================================

local ZM = 1946

ns.Q:RegisterRoute({
    key = "zangarmarsh-horde",
    title = "Zangarmarsh (Horde)",
    faction = "Horde",
    levels = "61-64",
    zones = { ZM },
    next = "terokkar-horde",
    steps = {
        -- ========================= Cenarion Refuge ==========================
        { type = "TRAVEL", label = "Cenarion Refuge",
          coords = { map = ZM, x = 78.5, y = 62.7 }, radius = 60,
          note = "Følg vejen fra Hellfire ind i Zangarmarsh. Cenarion Refuge ligger lige ved indgangen." },

        { type = "ACCEPT", title = "Plants of Zangarmarsh",
          coords = { map = ZM, x = 78.4, y = 62.2 },
          note = "Fra Lauranna Thar'well. Saml 10 Unidentified Plant Parts undervejs - de dropper fra planter og mobs i hele zonen." },

        { type = "ACCEPT", title = "Leader of the Bloodscale",
          coords = { map = ZM, x = 78.5, y = 63.0 },
          note = "Naga-quests fra Watcher Jhang ved Cenarion Refuge." },

        { type = "ACCEPT", title = "Leader of the Darkcrest",
          coords = { map = ZM, x = 78.5, y = 63.0 } },

        { type = "DO", title = "Leader of the Bloodscale",
          coords = { map = ZM, x = 81.5, y = 72.0 }, label = "Bloodscale Enclave",
          note = "Dræb Bloodscale-nagaerne sydøst for Cenarion Refuge. Lederen patruljerer i området." },

        -- ========================== Swamprat Post ===========================
        { type = "TRAVEL", label = "Swamprat Post",
          coords = { map = ZM, x = 71.8, y = 54.0 }, radius = 60,
          note = "Løb nordvest til Horde-forposten Swamprat Post og hent flight point'et." },

        { type = "ACCEPT", title = "Menacing Marshfangs",
          coords = { map = ZM, x = 71.8, y = 54.0 },
          note = "Saml quests op ved Swamprat Post." },

        { type = "DO", title = "Menacing Marshfangs",
          coords = { map = ZM, x = 74.5, y = 57.5 }, label = "Marshfangs",
          note = "Dræb Marshfang Rippers i området omkring Swamprat Post." },

        { type = "TURNIN", title = "Menacing Marshfangs",
          coords = { map = ZM, x = 71.8, y = 54.0 } },

        -- ============================ Zabra'jin =============================
        { type = "TRAVEL", label = "Zabra'jin",
          coords = { map = ZM, x = 34.8, y = 51.3 }, radius = 60,
          note = "Følg vejen vestpå gennem sumpen til troldebyen Zabra'jin (flight point)." },

        { type = "ACCEPT", title = "WANTED: Chieftain Mummaki",
          coords = { map = ZM, x = 35.2, y = 51.5 },
          note = "Wanted-plakaten hænger midt i Zabra'jin." },

        { type = "ACCEPT", title = "Ango'rosh Encroachment",
          coords = { map = ZM, x = 34.8, y = 51.3 },
          note = "Quests mod Ango'rosh-ogrerne nordvest for byen." },

        { type = "DO", title = "Ango'rosh Encroachment",
          coords = { map = ZM, x = 27.5, y = 32.5 }, label = "Ango'rosh Grounds",
          note = "Dræb Ango'rosh-ogrerne på deres svampe-platforme nordvest for Zabra'jin." },

        { type = "TURNIN", title = "Ango'rosh Encroachment",
          coords = { map = ZM, x = 34.8, y = 51.3 } },

        -- ============================ Sporeggar =============================
        { type = "TRAVEL", label = "Sporeggar",
          coords = { map = ZM, x = 18.7, y = 50.4 }, radius = 60,
          note = "Besøg sporeling-byen Sporeggar vest i zonen." },

        { type = "NOTE", label = "Sporeggar-quests",
          coords = { map = ZM, x = 18.7, y = 50.4 },
          note = "Saml Sporeggar-quests: Mature Spore Sacs, Glowcaps (bruges som valuta!) og Bog Lords for rep. Eskorten 'Fhwoor Smash!' giver god XP. Tryk 'Spring over', når du er færdig i området." },

        -- ==================== Serpent Lake og damppumperne ===================
        { type = "NOTE", label = "Drain Schematics",
          coords = { map = ZM, x = 43.0, y = 32.0 },
          note = "Dræb Steam Pump Overseers ved damppumperne omkring Serpent Lake, til der dropper 'Drain Schematics'. Genstanden starter en quest, der afleveres hos Ysiel Windsinger i Cenarion Refuge. Tryk 'Spring over', hvis du vil videre uden droppet." },

        { type = "DO", title = "Leader of the Darkcrest",
          coords = { map = ZM, x = 36.0, y = 60.0 }, label = "Darkcrest Enclave",
          note = "Dræb Darkcrest-nagaerne syd for Zabra'jin. Lederen patruljerer i området." },

        { type = "DO", title = "WANTED: Chieftain Mummaki",
          coords = { map = ZM, x = 84.5, y = 77.5 }, label = "Umbrafen Village",
          note = "Chieftain Mummaki holder til i stammens landsby i det sydøstlige Zangarmarsh." },

        -- =========================== Afleveringer ============================
        { type = "TURNIN", title = "Leader of the Bloodscale",
          coords = { map = ZM, x = 78.5, y = 63.0 }, label = "Cenarion Refuge",
          note = "Flyv/løb tilbage til Cenarion Refuge og aflever naga-questsene hos Watcher Jhang." },

        { type = "TURNIN", title = "Leader of the Darkcrest",
          coords = { map = ZM, x = 78.5, y = 63.0 } },

        { type = "TURNIN", title = "Plants of Zangarmarsh",
          coords = { map = ZM, x = 78.4, y = 62.2 },
          note = "Aflever plantedelene hos Lauranna Thar'well, når du har alle 10." },

        { type = "TURNIN", title = "WANTED: Chieftain Mummaki",
          coords = { map = ZM, x = 34.8, y = 51.3 }, label = "Zabra'jin",
          note = "Aflever dusøren i Zabra'jin." },

        -- ============================ Afslutning =============================
        { type = "NOTE", label = "Ryd op i Zangarmarsh", optional = true,
          coords = { map = ZM, x = 34.8, y = 51.3 },
          note = "Valgfrit: Ryd op i resterende quests i loggen (Daggerfen, Feralfen, Dead Mire m.fl.) indtil ca. level 63-64. Tryk 'Spring over', når du er klar." },

        { type = "TRAVEL", label = "Mod Terokkar Forest",
          coords = { map = ZM, x = 80.0, y = 66.0 }, radius = 80,
          note = "Følg vejen sydøst ud af Zangarmarsh mod Terokkar Forest. Qeasy skifter automatisk til Terokkar-ruten." },
    },
})
