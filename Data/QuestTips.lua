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

-- Delt tip til "Enraged Spirits of X"-quests (Shadowmoon, samme mekanik).
local ENRAGED_SPIRITS = {
    "Læg 'Totem of Spirits' på jorden TÆT på den vrede elemental og dræb den så inden for totem'ets rækkevidde - kun da fanges dens sjæl. Dræber du den uden totem i nærheden, tæller den ikke.",
}

-- Delt tip til Teron Gorefiend-divinations-quests (Shadowmoon).
local GOREFIEND_DIV = {
    "Du kan KUN se og ramme spøgelserne mens du bærer den aske-fyldte hjelm fra 'Teron Gorefiend - Lore and Legend'. Tag hjelmen på, før du leder efter målet.",
}

-- Delt tip til de mange "Shutting Down Manaforge X"-quests (samme mekanik).
local MANAFORGE = {
    "Dræb Overseer'en for at få manaforgens 'Access Crystal' - brug så krystallen på Control Console for at lukke den ned. Selve nedlukningen sker med det UDLEVEREDE item, ikke ved at dræbe alt.",
    "Der findes en Aldor- OG en Scryer-version af hver manaforge; tag kun den fra din egen fraktions questgiver (den anden sænker din modsatte rep).",
}

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
    [10087] = {  -- Burn It Up... For the Horde!
        "Brug 'Flaming Torch' på den vestlige OG den østlige Alliance Cannon på Path of Glory - du skal bruge det udleverede item på begge kanoner.",
    },
    [9447] = {  -- Administering the Salve
        "Brug det udleverede salve-item på de sårede 'Debilitated Mag'har Grunt' (venlige, ikke fjender) - du helbreder dem, du dræber dem ikke.",
    },
    -- Arelion-kæden (Falcon Watch): spion-historie med to item-/duel-trin.
    [9472] = {  -- Arelion's Mistress
        "Lok Viera Sunwhisper væk fra lejren med cenarion-vin (hentes ved Cenarion Refuge), og brug så 'Carinda's Scroll of Retribution' på hende.",
    },
    [10286] = {  -- Arelion's Secret
        "Magister Aledis rider rundt på vejen mellem Falcon Watch og Zangarmarsh. Snak med ham ved fuldt liv - det starter en duel; få ham under 30% liv for at fuldføre.",
    },

    -- ===================== Zangarmarsh =====================
    [9785] = {  -- Blessings of the Ancients
        "Der er TO ancients ved Cenarion Refuge: Ashyen og Keleth. Snak med begge.",
        "Hver ancient giver dig valget mellem to buffs - vælg efter behov (en er nyttig til Sporeggar/Cenarion-rep-grind).",
    },
    [9738] = {  -- Lost in Action
        "Dungeon-quest: de fire savnede (Rayge, Bite, Greenthumb, Claw) findes INDE i Slave Pens og Underbog (Coilfang-instanserne) - ikke ude i det fri. Tag den med, når du kører de dungeons.",
    },
    [9701] = {  -- Observing the Sporelings (kæde-start)
        "Start på sporeling-kæden fra Watcher Leesa'oh (Cenarion Watchpost): flere korte quests i træk om sporelingerne, bog lords og Ango'rosh-ograne - tag dem samlet, det er samme område.",
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
    [11029] = {  -- A Shabby Disguise (Skettis)
        "Tag forklædningen PÅ og snak med arakkoa-skriveren Sahaak på Terokk's Rest (midterøen i Skettis). Forklædningen narrer KUN Sahaak - de andre arakkoa gennemskuer dig, så hold afstand.",
    },
    [11085] = {  -- Escape from Skettis
        "Escort/daily: befri Skyguard-fangen fra hans bur i en af Skettis' veils - han går derefter langsomt mod en bro. Beskyt ham hele vejen og rapportér til Sky Sergeant Doryn.",
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
    [10682] = {  -- A Time for Negotiation...
        "Forhandlings-quest: snak med Overseer Nuaar (~60,34, nord for Tree Warden Chawn) - der er ikke noget at dræbe. Følg pilen til ham.",
    },
    [10714] = {  -- On Spirit's Wings
        "Aflytnings-quest: find et par Bloodmaul-ogrer (Taskmaster + Soothsayer) i den østlige kløft nord for Circle of Blood (~58,31), og brug 'Rexxar's Whistle' for at sende Spirit ud og lytte. Der er ikke noget at dræbe.",
    },
    [10859] = {  -- Gather the Orbs
        "Razaani Light Orbs står tæt samlet i Razaani-området øst i zonen (~66,42, mod Bash'ir Landing) - de er interaktive 'lys', ikke mobs. Følg pilen til klyngen.",
    },
    [10867] = {  -- There Can Be Only One Response
        "Dræb de samme Razaani-ethereals som i 'Gather the Orbs' (~66,42), indtil en boss spawner og dropper 'Collection of Souls'. Saml den og aflever hos Spiritcaller Dohgar.",
    },
    -- T'chali-kæden (Thunderlord-outpost, sydvest): 10542 -> 10545 -> 10543 -> 10544.
    [10543] = {  -- Grimnok and Korgaah, I Am For You!
        "To navngivne Bladespire-ogrer på HVER sit sted i Bladespire Hold (Grimnok mod syd, Korgaah mod nord) - dræb begge. De står ikke sammen.",
    },
    [10544] = {  -- A Curse Upon Both of Your Clans!
        "Brug 'Wicked Strong Fetish' ved de markerede bygninger inde i Bladespire Hold (Qeasy viser stederne på kortet).",
    },
    [10505] = {  -- The Bloodmaul Ogres
        "Alle Bloodmaul-mobs tæller (brute, shaman, geomancer m.fl.) - de holder til i Bloodmaul-lejren i sydøst. Ryd bare igennem.",
    },
    -- Legion-infiltration (Toshley's/Wildlord Antelarion): forklædnings-kæde.
    [10819] = {  -- Felsworn Gas Mask
        "Tag 'Felsworn Gas Mask' PÅ, gå ind i Forge Camp: Anger (øst) og brug 'Legion Communicator'. Masken holder 1 time - mister du den, får du en ny hos Wildlord Antelarion.",
    },
    [10820] = {  -- Deceive thy Enemy
        "Bær stadig masken: dræb 4 Doomforge Attendants og 4 Doomforge Engineers i Forge Camp: Anger. Selve questen tager du ved at højreklikke 'Legion Communicator' med masken på.",
    },
    [11010] = {  -- Bombing Run
        "Flyve-bombe-quest fra Sky Sergeant Vanderlip ved Skyguard-outposten (kræver flyvemount). Tag flyvemaskinen og kast bomber på målene undervejs - ingen mobs at dræbe manuelt.",
    },
    -- ----- Ogri'la / Skyguard (level 70, kræver flyvemount) -----
    [11009] = {  -- Ogre Heaven
        "Låser Ogri'la-hubben op oppe på plateauet (du skal have et flyvemount for at komme derop). Snak med Chu'a'lor.",
    },
    [11025] = {  -- The Crystals
        "Apexis-relikvierne er et 'Simon siger'-spil: læg en apexis-shard i, og gentag farve-sekvensen relikvien viser. Den bliver sværere for hvert trin.",
    },
    [11065] = {  -- Wrangle Some Aether Rays!
        "Skad en Aether Ray ned til ~20% liv og VENT på emote'en om at den er klar - brug så 'Wrangling Rope' til at fange den. De flyver omkring Vortex Pinnacle.",
    },
    [11078] = {  -- To Rule The Skies
        "Gruppe-quest (3-5 spillere): knæk et drage-æg med 35 apexis-shards for at kalde én af de fire drager (Rivendark, Obsidia, Furywing, Insidion) ned. De er Onyxia-kloner - tag en gruppe og et flyvemount med.",
    },
    [10995] = {  -- Grulloc Has Two Skulls
        "Gruppe-quest (level 70): Grulloc er en gronn der rammer meget hårdt - tag en fuld gruppe med. Kraniet kan lootes af alle, også dem der ikke deltog i drabet.",
    },

    -- ===================== Netherstorm =====================
    [10243] = {  -- Naaru Technology
        "Aflever ved 'B'naar Control Console' (et objekt, ikke en NPC) inde i Manaforge B'naar - brug konsollen.",
    },
    -- Manaforge-nedlukninger: Aldor-linjen (Anchorite Karja) ...
    [10299] = MANAFORGE,  -- B'naar
    [10321] = MANAFORGE,  -- Coruu
    [10322] = MANAFORGE,  -- Duro
    [10323] = MANAFORGE,  -- Ara
    -- ... og Scryer-linjen (Spymaster Thalodien / Caledis Brightdawn).
    [10329] = MANAFORGE,  -- B'naar
    [10330] = MANAFORGE,  -- Coruu
    [10338] = MANAFORGE,  -- Duro
    [10365] = MANAFORGE,  -- Ara
    [10855] = {  -- Fel Reavers, No Thanks! (+ Nether Gas In a Fel Fire Engine)
        "Dræb Gan'arg Mekgineers for 'Condensed Nether Gas', og HÆLD den så i en 'Inactive Fel Reaver' (brug item'et på reaveren) - forkert brændstof saboterer den. Du skal ikke nedkæmpe reaveren.",
    },
    [10426] = {  -- Flora of the Eco-Domes
        "Brug det udleverede redskab på planterne inde i Eco-Dome'erne (Biodome-kuplerne) - du skal samle prøver, ikke slås.",
    },
    [10427] = {  -- Creatures of the Eco-Domes
        "Samme kupler som 'Flora of the Eco-Domes': brug det udleverede redskab på skabningerne indenfor - tag begge quests i én tur.",
    },
    [10385] = {  -- Potential for Brain Damage = High
        "Gruppe-quest (level 70): Nexus-King Salhadaar og hans Ethereum-vagter ved Staging Grounds er elite - tag en gruppe med.",
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
    -- Enraged Spirits (Earthmender Torlok): totem-fangst.
    [10458] = ENRAGED_SPIRITS,  -- Fire and Earth
    [10480] = ENRAGED_SPIRITS,  -- Water
    [10481] = ENRAGED_SPIRITS,  -- Air
    -- Teron Gorefiend-kæden: aske-hjelm gør spøgelserne synlige.
    [10633] = {  -- Teron Gorefiend - Lore and Legend
        "Questen giver dig en aske-fyldt hjelm - tag den PÅ for at kunne se Shadowmoons spøgelser. Uden hjelmen er målene til de tre 'Divination'-quests usynlige.",
    },
    [10634] = GOREFIEND_DIV,  -- Gorefiend's Armor
    [10635] = GOREFIEND_DIV,  -- Gorefiend's Cloak
    [10636] = GOREFIEND_DIV,  -- Gorefiend's Truncheon
    -- Netherwing-intro (level 70, kræver flyvemount).
    [10836] = {  -- Infiltrating Dragonmaw Fortress
        "Dræb 15 Dragonmaw-orker inde i Dragonmaw Fortress (sydøst, ~66,60). Ingen forklædning - bare ryd igennem.",
    },
    [10837] = {  -- To Netherwing Ledge!
        "Flyv ud til Netherwing Ledge - den svævende ø mod syd (kræver flyvemount). Loot 'Nethervine Crystal' fra de tornede ranker ved de store krystal-klynger.",
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
