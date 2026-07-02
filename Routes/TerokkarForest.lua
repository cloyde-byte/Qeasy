local _, ns = ...

-- =========================================================================
-- Terokkar Forest (Horde) - level 62-65
--
-- Rækkefølgen følger Wowheads "Terokkar Forest Horde Leveling Quest Guide"
-- for Burning Crusade Classic. Quest-id'er og koordinater er best-effort:
-- mangler et id (nil), matcher addonet på quest-titlen og lærer selv
-- id'et, når questen accepteres i spillet.
--
-- Koordinater er zone-procenter (x, y) på uiMapID 1952 = Terokkar Forest.
-- =========================================================================

local TF = 1952

ns.Q:RegisterRoute({
    key = "terokkar-horde",
    title = "Terokkar Forest (Horde)",
    faction = "Horde",
    levels = "62-65",
    zones = { TF },
    next = "nagrand-horde",
    steps = {
        -- ========================= Cenarion Thicket ==========================
        { type = "TRAVEL", label = "Cenarion Thicket",
          coords = { map = TF, x = 44.0, y = 26.0 }, radius = 60,
          note = "Følg vejen fra Zangarmarsh ind i Terokkar Forest. Cenarion Thicket ligger ved indgangen mod nordvest." },

        { type = "NOTE", label = "Cenarion Thicket-quests",
          coords = { map = TF, x = 44.0, y = 26.0 },
          note = "Saml de lokale Cenarion-quests op og løs dem i området (undersøg det ødelagte tårn og dræb de korrupte dyr). Tryk 'Spring over', når du er færdig her." },

        -- ========================= Stonebreaker Hold =========================
        { type = "TRAVEL", label = "Stonebreaker Hold",
          coords = { map = TF, x = 49.3, y = 44.0 }, radius = 60,
          note = "Løb sydøst til Horde-basen Stonebreaker Hold og hent flight point'et." },

        { type = "NOTE", label = "Stonebreaker Hold-quests",
          coords = { map = TF, x = 49.3, y = 44.0 },
          note = "Saml alle quests op ved Stonebreaker Hold - de peger mod Tuurem, skovens dyr og Firewing Point. Tryk 'Spring over', når loggen er fyldt." },

        { type = "ACCEPT", title = "Magical Disturbances",
          coords = { map = TF, x = 49.3, y = 44.0 },
          note = "Fra Stonebreaker Hold." },

        { type = "DO", title = "Magical Disturbances",
          coords = { map = TF, x = 54.0, y = 35.0 }, label = "Tuurem",
          note = "Løs questen ved Broken-landsbyen Tuurem nordøst for Stonebreaker Hold." },

        { type = "TURNIN", title = "Magical Disturbances",
          coords = { map = TF, x = 49.3, y = 44.0 } },

        { type = "NOTE", label = "Firewing Point", optional = true,
          coords = { map = TF, x = 70.0, y = 37.0 },
          note = "Firewing Point mod øst: blood elf-fæstning med en god quest-klynge. Toppen af tårnet er elite-område - tag evt. en makker med. Tryk 'Spring over', når du er færdig." },

        -- ============================ Shattrath ==============================
        { type = "TRAVEL", label = "Shattrath City",
          coords = { map = TF, x = 34.0, y = 22.5 }, radius = 80,
          note = "Besøg Shattrath City: hent flight point'et, og overvej at binde din hearthstone her - det er Outlands centrale by." },

        { type = "NOTE", label = "Shattrath rundtur",
          coords = { map = TF, x = 34.0, y = 22.5 },
          note = "Tag byrundvisnings-questen i Shattrath (starter ved indgangen) og se A'dal i Terrace of Light. Valget mellem Aldor og Scryers kan vente - lad være med at binde dig endnu. Tryk 'Spring over' bagefter." },

        -- =========================== Bone Wastes =============================
        { type = "TRAVEL", label = "Refugee Caravan",
          coords = { map = TF, x = 37.0, y = 50.0 }, radius = 60,
          note = "Syd for Shattrath ligger Bone Wastes. Flygtninge-karavanen midt i asken har flere quests." },

        { type = "NOTE", label = "Bone Wastes-quests",
          coords = { map = TF, x = 37.0, y = 50.0 },
          note = "Saml quests op ved karavanen og ved Auchindouns ringmur. Tryk 'Spring over', når loggen er fyldt." },

        { type = "ACCEPT", title = "Torgos!",
          coords = { map = TF, x = 37.0, y = 50.0 },
          note = "Dusør på kæmpegribben Torgos." },

        { type = "DO", title = "Torgos!",
          coords = { map = TF, x = 42.0, y = 66.0 }, label = "Torgos",
          note = "Torgos kredser over den østlige del af Bone Wastes." },

        { type = "TURNIN", title = "Torgos!",
          coords = { map = TF, x = 37.0, y = 50.0 } },

        { type = "ACCEPT", title = "Missing Friends",
          coords = { map = TF, x = 34.0, y = 23.0 }, label = "Lower City",
          note = "Fra Lower City i Shattrath: børnene fra karavanen er blevet bortført af arakkoa." },

        { type = "DO", title = "Missing Friends",
          coords = { map = TF, x = 36.0, y = 65.0 }, label = "Veil Skith",
          note = "Befri de tilfangetagne børn i arakkoa-landsbyen Veil Skith sydvest i skoven." },

        { type = "TURNIN", title = "Missing Friends",
          coords = { map = TF, x = 34.0, y = 23.0 }, label = "Lower City" },

        -- ============================ Afslutning =============================
        { type = "NOTE", label = "Ryd op i Terokkar", optional = true,
          coords = { map = TF, x = 49.3, y = 44.0 },
          note = "Valgfrit: Ryd op i resterende quests (arakkoa-lejrene, Auchindoun-ringen, Skettis-forløberne) indtil ca. level 64-65. Tryk 'Spring over', når du er klar." },

        { type = "TRAVEL", label = "Mod Nagrand",
          coords = { map = TF, x = 29.0, y = 47.0 }, radius = 80,
          note = "Følg vejen vest ud af Bone Wastes mod Nagrand. Qeasy skifter automatisk til Nagrand-ruten." },
    },
})
