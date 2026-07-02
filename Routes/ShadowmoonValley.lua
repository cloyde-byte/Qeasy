local _, ns = ...

-- =========================================================================
-- Shadowmoon Valley (Horde) - level 67-70
--
-- Rækkefølgen følger Wowheads "Shadowmoon Valley Horde Leveling Quest
-- Guide" for Burning Crusade Classic. Quest-id'er og koordinater er
-- best-effort: mangler et id (nil), matcher addonet på quest-titlen og
-- lærer selv id'et, når questen accepteres i spillet.
--
-- Koordinater er zone-procenter (x, y) på uiMapID 1948 = Shadowmoon Valley.
-- =========================================================================

local SMV = 1948

ns.Q:RegisterRoute({
    key = "shadowmoon-horde",
    title = "Shadowmoon Valley (Horde)",
    faction = "Horde",
    levels = "67-70",
    zones = { SMV },
    steps = {
        -- ======================== Shadowmoon Village =========================
        { type = "TRAVEL", label = "Shadowmoon Village",
          coords = { map = SMV, x = 30.0, y = 28.0 }, radius = 60,
          note = "Horde-byen Shadowmoon Village i nordvest (flight point) er din base i zonen." },

        { type = "NOTE", label = "Shadowmoon Village-quests",
          coords = { map = SMV, x = 30.0, y = 28.0 },
          note = "Saml alle quests op i byen - de peger mod Legion Hold, vulkanen og dalens dyr. Tryk 'Spring over', når loggen er fyldt." },

        { type = "ACCEPT", title = "Spectrecles",
          coords = { map = SMV, x = 30.0, y = 28.0 },
          note = "Spøgelses-brillerne 'Spectrecles' lader dig se og hjælpe de faldne orc-ånder omkring byen." },

        { type = "DO", title = "Spectrecles",
          coords = { map = SMV, x = 32.0, y = 30.0 }, label = "Orc-ånder",
          note = "Tag brillerne på og løs ånde-questsene omkring landsbyen." },

        -- =========================== Legion Hold =============================
        { type = "NOTE", label = "Legion Hold",
          coords = { map = SMV, x = 25.0, y = 39.0 },
          note = "Spionér ved Legion Hold sydvest for byen og gennemfør questsene mod Legionens belejring (kulminerer med at observere/bombe deres anlæg). Pas på - området er tæt pakket med dæmoner. Tryk 'Spring over', når du er færdig." },

        -- ========================= Hand of Gul'dan ===========================
        { type = "NOTE", label = "Hand of Gul'dan",
          coords = { map = SMV, x = 55.0, y = 48.0 },
          note = "Vulkanen Hand of Gul'dan midt i dalen: løs questsene omkring de flammende elementarer og Legionens gravearbejde. Tryk 'Spring over', når du er færdig." },

        { type = "ACCEPT", title = "Wanted: Uvuros, Scourge of Shadowmoon", optional = true,
          coords = { map = SMV, x = 30.0, y = 28.0 },
          note = "Dusør-opslag i Shadowmoon Village på fel-hunden Uvuros." },

        { type = "DO", title = "Wanted: Uvuros, Scourge of Shadowmoon", optional = true,
          coords = { map = SMV, x = 52.0, y = 47.0 }, label = "Uvuros",
          note = "Uvuros patruljerer i skoven nær Hand of Gul'dan. Hård modstander - tag evt. en makker med." },

        { type = "TURNIN", title = "Wanted: Uvuros, Scourge of Shadowmoon", optional = true,
          coords = { map = SMV, x = 30.0, y = 28.0 } },

        -- ==================== The Cipher of Damnation ========================
        { type = "NOTE", label = "Oronok Torn-heart (Cipher of Damnation)",
          coords = { map = SMV, x = 59.0, y = 46.0 },
          note = "Besøg Oronok Torn-heart ved hans hytte: 'The Cipher of Damnation' er zonens store kæde - du hjælper hans sønner og samler cipher-delene. Fremragende XP og afslutning på dalens historie. Tryk 'Spring over', når kæden er færdig." },

        -- ==================== Sanctum of the Stars m.m. ======================
        { type = "NOTE", label = "Sanctum of the Stars / Altar of Sha'tar", optional = true,
          coords = { map = SMV, x = 56.0, y = 60.0 },
          note = "Valgfrit: Scryers' Sanctum of the Stars (eller Aldors Altar of Sha'tar) har quests fra level 69-70 og daglige opgaver - godt sted at starte dit endgame-ry. Tryk 'Spring over'." },

        -- ============================ Afslutning =============================
        { type = "NOTE", label = "Tillykke med level 70!",
          coords = { map = SMV, x = 30.0, y = 28.0 },
          note = "Du er i mål! Herfra venter Netherwing-ry (elite-området Netherwing Ledge), dungeons, heroics og Karazhan-attunement. Tak fordi du levelede med Qeasy - tryk 'Spring over' for at afslutte ruten." },
    },
})
