local _, ns = ...

-- =========================================================================
-- Qeasy QuestTips: HÅNDSKREVNE tips til enkelte quests (i modsætning til den
-- genererede QuestDB). Vises i guide-vinduet for den/de quests du har i fokus.
-- Formålet er "lokal viden" som rå data ikke fanger: skjulte mekanikker,
-- smarte ruter, items man skal huske, gruppe-behov osv.
--
--   ns.QuestTips[questID] = { "tip 1", "tip 2", ... }
--
-- Hver tip er tjekket mod questens faktiske kill/interact-koordinater, enheder
-- og afleveringssted i OutlandQuests.lua, så de ikke peger forkert. Ret og
-- tilføj frit - nøglen er quest-id'et (samme som i QuestDB).
-- =========================================================================

ns.QuestTips = {
    -- ===================== Hellfire Peninsula =====================
    [10792] = {  -- Zeth'Gor Must Burn!
        "Brug 'Smoldering Torch' på de markerede bygninger i Zeth'Gor (sydøst) - stå tæt på bygningen og aktivér faklen. Du behøver ikke rydde området først.",
    },
    [10809] = {  -- Wanted: Worg Master Kruush
        "Kruush er inde i Zeth'Gor (sydøst) - tag den samtidig med 'Zeth'Gor Must Burn!'. Kun han dropper 'Worg Master's Head'.",
    },
    [10392] = {  -- Doorway to the Abyss
        "Dræb FØRST Warbringer Arix'Amal ved Invasion Point: Annihilator (nord for Thrallmar) for at få 'Burning Legion Gate Key'.",
        "Brug så nøglen på 'Rune of Spite' ved portalen - det er selve mål-objektet pilen fører dig til.",
    },

    -- ===================== Zangarmarsh =====================
    [9785] = {  -- Blessings of the Ancients
        "Der er TO ancients ved Cenarion Refuge: Ashyen og Keleth. Snak med begge.",
        "Hver ancient giver dig valget mellem to buffs - vælg efter behov (en er nyttig til Sporeggar/Cenarion-rep-grind).",
    },
    [9738] = {  -- Lost in Action
        "Dungeon-quest: de fire savnede (Rayge, Bite, Greenthumb, Claw) findes INDE i Slave Pens og Underbog (Coilfang-instanserne) - ikke ude i det fri. Tag den med, når du kører de dungeons.",
    },

    [9788] = {  -- A Damp, Dark Place
        "Ikeyen's Belongings ligger i en HULE i det nordøstlige Nagrand, nær grænsen til Zangarmarsh (Umbrafen-området) - ikke ude i det fri.",
        "Følg pilen helt hen til hulen og gå indenfor for at samle ejendelene.",
    },

    -- ===================== Terokkar Forest =====================
    [10412] = {  -- Firewing Signets (+ 10414/10415, Attack on Firewing Point, The Firewing Liaison)
        "Firewing Point (øst) har flere quests på de samme blood elf-mobs - tag 'Attack on Firewing Point', 'The Firewing Liaison' m.fl. med og ryd området én gang.",
    },
    [10036] = {  -- Torgos!
        "Torgos er en sjælden spawn - er han der ikke, så dræb Trachela og kom igen senere. Kun Torgos dropper 'Tail Feather of Torgos'.",
    },
    [10898] = {  -- Skywing
        "Escort-quest: Skywing følger dig. Ryd arakkoa-fjenderne på vejen FØR du starter, og hold dig mellem Skywing og fjenderne. Aflever hos Rilak the Redeemed i Skettis.",
    },
    [11506] = {  -- Spirits of Auchindoun
        "PvP-quest: du kæmper om kontrollen over de fire spirit towers ved Auchindoun - forvent fjendtlige spillere. Nemmest med et par allierede.",
    },
    [10922] = {  -- Digging Through Bones
        "Forsvars-quest: beskyt Chief Archaeologist Letoll og hans grave-hold mod en bone worm, mens de graver lidt nord for Sha'tari-lejren.",
        "Ingen af holdet må dø - hold dig tæt på dem. Aflever hos Dwarfowitz, når udgravningen er færdig.",
    },

    -- ===================== Nagrand =====================
    -- Nesingwary-jagtquests: de tre 'Mastery'-kæder deler jagtmarker.
    [9789] = { "Clefthoof, Talbuk og Windroc Mastery deler samme jagtmarker - tag alle tre kæder samtidig og dræb på kryds og tværs." },
    [9857] = { "Clefthoof, Talbuk og Windroc Mastery deler samme jagtmarker - tag alle tre kæder samtidig og dræb på kryds og tværs." },
    [9854] = { "Clefthoof, Talbuk og Windroc Mastery deler samme jagtmarker - tag alle tre kæder samtidig og dræb på kryds og tværs." },
    [9882] = {  -- Stealing from Thieves
        "Du er helt i sydvest - tag også de andre Sunspring-quests (fx 'Shattering the Veil') med, mens du er hernede.",
    },
    [9815] = {  -- Muck Diving
        "Trods navnet skal du ikke dykke dybt: dræb Muck Spawns ved vandkanten (følg pilen). De dukker op omkring vandet.",
    },
    [9800] = {  -- A Rare Bean
        "Belønningen er en 'Nagrand Cherry' (5 min. vejrtrækning under vand). GEM den - du skal bruge den til follow-up'en 'Agitated Spirits of Skysong', hvor du skal dykke.",
    },
    [9804] = {  -- Agitated Spirits of Skysong
        "Spis en 'Nagrand Cherry' (fra 'A Rare Bean') FØR du dykker, så du kan ånde under vand.",
        "Lake Spirits står på bunden af Skysong Lake (nær Throne of Elements i nordøst) - dyk ned og dræb dem der.",
    },
    [9962] = {  -- The Ring of Blood (kæden starter her)
        "Ring of Blood er en arena-serie: én elite-modstander ad gangen, i fast rækkefølge fra Gurgthock.",
        "Du kan få hjælp fra andre spillere ved arenaen - mange venter der. Belønnings-våbnene er blandt de bedste før level 70.",
        "Sidste kamp (Mogor) er hårdest - gem lidt forsyninger til den.",
    },
    [9946] = {  -- Cho'war the Pillager
        "Cho'war står helt oppe i det nordvestlige hjørne af Nagrand - følg pilen. Kun han dropper 'Head of Cho'war'.",
        "Tag 'War on the Warmaul' med samme vej (samme retning, samme fjender undervejs).",
    },
    [9937] = {  -- Wanted: Durn the Hungerer
        "Durn er en STOR elite-ogre der patruljerer i sydvest (nær Warmaul Hill). Tag et par med, eller vær et par levels over - han rammer hårdt.",
    },

    -- ===================== Blade's Edge Mountains =====================
    [10524] = {  -- Thunderlord Clan Artifacts
        "Tre forskellige artefakter på tre steder langs Thunderlord-ruinerne: Drum (syd), Arrow (midt), Tablet (nord). Qeasy fjerner et mærke fra kortet, så snart du har samlet det.",
        "Aflever alle tre hos Rokgah Bloodgrip.",
    },
    [10545] = {  -- Bladespire Kegger
        "Brug T'chalis øl-tønder på de markerede steder inde i Bladespire Hold - ogrerne drikker og bliver fulde. Du skal ikke dræbe dem.",
    },
    [10614] = {  -- Whispers on the Wind
        "Ren leverings-quest: der er intet at dræbe. Løb østpå til Leoroxx i Mok'Nathal Village og aflever. Derfor vises den ikke med mål-ikoner på kortet.",
    },
    [11010] = {  -- Bombing Run
        "Flyve-bombe-quest: tag flyvemaskinen fra questgiveren i Evergrove og kast bomber på målene undervejs - ingen mobs at dræbe manuelt.",
    },

    -- ===================== Netherstorm =====================
    [10243] = {  -- Naaru Technology
        "Aflever ved 'B'naar Control Console' (et objekt, ikke en NPC) inde i Manaforge B'naar - brug konsollen.",
    },
    [10439] = {  -- Dimensius the All-Devouring
        "Dimensius er en stor gruppe-kamp: du hjælper Captain Saeed og hans styrke. Vær flere (eller kom tilbage på max level) og følg Saeed, når han rykker frem.",
    },

    -- ===================== Shadowmoon Valley =====================
    [10519] = {  -- The Cipher of Damnation - Truth and History (Oronok-kæden forgrener sig her)
        "Herfra sender Oronok dig til sine tre sønner - Grom'tor, Ar'tor og Borak - i hver sin del af Shadowmoon. Tag alle tre spor (vilkårlig rækkefølge) og saml de tre fragmenter før finalen.",
    },
    [10451] = {  -- Escape from Coilskar Cistern
        "Escort: Earthmender Wilda følger dig ud af Coilskar Cistern og bliver angrebet undervejs. Hun heler, men beskyt hende. Starter Cipher of Damnation-kæden.",
    },
    [10647] = {  -- Wanted: Uvuros, Scourge of Shadowmoon
        "Uvuros er en stor, patruljerende elite - bring hjælp. Kun han dropper 'Uvuros's Fiery Mane'.",
    },
    [11544] = {  -- Ata'mal Armaments (+ The Ata'mal Terrace)
        "Ata'mal Terrace ligger øst i Shadowmoon - tag 'The Ata'mal Terrace' med samtidig (samme område). Pas på Shadowlord Deathwail; han er en mini-boss.",
    },

    -- ===================== Shattrath / Lower City-bounties =====================
    [11354] = {  -- Wanted: (dungeon-bounties fra Wind Trader Zhareem)
        "Disse 'Wanted:'-bounties dropper fra bosser i Outland-dungeons. Du kan kun have ÉN item-bounty ad gangen - vælg den, der passer til den instans du skal i.",
        "Aflever hos Wind Trader Zhareem i Shattrath (Lower City).",
    },
    [11364] = {  -- Wanted: Shattered Hand Centurions (kill-bounties fra Mah'duun)
        "Kill-bounties fra Nether-Stalker Mah'duun tælles ved at dræbe mobs i dungeons. Også her: kun én ad gangen - vælg efter din instans.",
    },
}
