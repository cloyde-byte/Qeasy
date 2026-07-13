local _, ns = ...

-- =========================================================================
-- Blade's Edge Mountains (Horde) - level 65-68
--
-- Rækkefølgen følger Wowheads leveling-guide for Burning Crusade Classic.
-- Quest-id'er og koordinater er verificeret mod pfQuest-databasen
-- (https://github.com/shagu/pfQuest, MIT-licens, © Eric Mauser/Shagu).
-- Ruten er GENERERET af tools/plans.py - rediger ikke i hånden.
--
-- Format: grupperede steps med elementer (kind = accept|do|turnin|travel|
-- fly|hearth|train|vendor|buy|note|ding|grind). Koordinater er zone-
-- procenter (x, y) på uiMapID:
--   1949 = Blade's Edge Mountains, 1953 = Netherstorm
-- =========================================================================

ns.Q:RegisterRoute({
    key = "blades-edge-horde",
    title = "Blade's Edge Mountains (Horde)",
    faction = "Horde",
    levels = "65-68",
    zones = { 1949 },
    next = "netherstorm-horde",
    steps = {
        { label = "Thunderlord Stronghold", elements = {
                { kind = "travel", coords = { map = 1949, x = 51.9, y = 58.4 }, radius = 60,
                  text = "Thunderlord Stronghold", note = "Horde-basen Thunderlord Stronghold midt i zonen (flight point)." },
        }},
        { label = "Thunderlord Stronghold", elements = {
                { kind = "accept", quest = 10503, title = "The Bladespire Threat",
                  coords = { map = 1949, x = 51.9, y = 58.4 }, note = "Fra Tor'chunk Twoclaws." },
                { kind = "accept", quest = 10505, title = "The Bloodmaul Ogres",
                  coords = { map = 1949, x = 51.9, y = 58.4 }, note = "Fra Tor'chunk Twoclaws." },
                { kind = "accept", quest = 10486, title = "The Encroaching Wilderness",
                  coords = { map = 1949, x = 52.4, y = 57.9 }, note = "Fra Gor'drek." },
                { kind = "accept", quest = 10489, title = "Felling an Ancient Tree",
                  coords = { map = 1949, x = 51.9, y = 57.8 }, note = "Wanted-plakat." },
        }},
        { label = "Thunderlord Stronghold", elements = {
                { kind = "do", quest = 10503, title = "The Bladespire Threat",
                  coords = { map = 1949, x = 45.0, y = 50.0 }, note = "Spionér på Bladespire-ogrerne i deres fæstning (nordvest)." },
        }},
        { label = "Thunderlord Stronghold", elements = {
                { kind = "do", quest = 10505, title = "The Bloodmaul Ogres",
                  coords = { map = 1949, x = 45.0, y = 62.0 }, note = "Dræb Bloodmaul-ogrer sydvest for holden." },
        }},
        { label = "Thunderlord Stronghold", elements = {
                { kind = "do", quest = 10486, title = "The Encroaching Wilderness",
                  coords = { map = 1949, x = 50.0, y = 60.0 }, note = "Dræb dyr, der truer holden." },
        }},
        { label = "Thunderlord Stronghold", elements = {
                { kind = "do", quest = 10489, title = "Felling an Ancient Tree",
                  coords = { map = 1949, x = 48.0, y = 63.0 }, note = "Fæld det gamle træ (brug øksen ved træet)." },
        }},
        { label = "Thunderlord Stronghold", elements = {
                { kind = "turnin", quest = 10503, title = "The Bladespire Threat",
                  coords = { map = 1949, x = 51.9, y = 58.4 }, note = "Aflever hos Tor'chunk Twoclaws." },
                { kind = "turnin", quest = 10505, title = "The Bloodmaul Ogres",
                  coords = { map = 1949, x = 51.9, y = 58.4 }, note = "Aflever hos Tor'chunk Twoclaws." },
                { kind = "turnin", quest = 10486, title = "The Encroaching Wilderness",
                  coords = { map = 1949, x = 52.4, y = 57.9 }, note = "Aflever hos Gor'drek." },
                { kind = "turnin", quest = 10489, title = "Felling an Ancient Tree",
                  coords = { map = 1949, x = 51.9, y = 58.4 }, note = "Aflever hos Tor'chunk Twoclaws." },
                { kind = "accept", quest = 10487, title = "Dust from the Drakes",
                  coords = { map = 1949, x = 52.4, y = 57.9 }, note = "Fra Gor'drek." },
        }},
        { label = "Thunderlord Stronghold", elements = {
                { kind = "do", quest = 10487, title = "Dust from the Drakes",
                  coords = { map = 1949, x = 44.0, y = 66.0 }, note = "Saml støv fra drakerne ved Dragons' End." },
        }},
        { label = "Thunderlord Stronghold", elements = {
                { kind = "turnin", quest = 10487, title = "Dust from the Drakes",
                  coords = { map = 1949, x = 52.4, y = 57.9 }, note = "Aflever hos Gor'drek." },
        }},
        { label = "Mok'Nathal Village og Rexxar", elements = {
                { kind = "accept", quest = 10614, title = "Whispers on the Wind",
                  coords = { map = 1949, x = 51.8, y = 58.3 }, note = "Fra Rexxar (ved Thunderlord)." },
        }},
        { label = "Mok'Nathal Village og Rexxar", elements = {
                { kind = "travel", coords = { map = 1949, x = 75.3, y = 60.9 }, radius = 60,
                  text = "Mok'Nathal Village", note = "Halvogrenes landsby i sydøst (flight point) - Rexxars far Leoroxx." },
        }},
        { label = "Mok'Nathal Village og Rexxar", elements = {
                { kind = "turnin", quest = 10614, title = "Whispers on the Wind",
                  coords = { map = 1949, x = 75.3, y = 60.9 }, note = "Aflever hos Leoroxx." },
                { kind = "accept", quest = 10709, title = "Reunion",
                  coords = { map = 1949, x = 75.3, y = 60.9 }, note = "Fra Leoroxx." },
        }},
        { label = "Mok'Nathal Village og Rexxar", elements = {
                { kind = "do", quest = 10709, title = "Reunion",
                  coords = { map = 1949, x = 72.0, y = 58.0 }, note = "Klar opgaven for Leoroxx i dalene." },
        }},
        { label = "Mok'Nathal Village og Rexxar", elements = {
                { kind = "turnin", quest = 10709, title = "Reunion",
                  coords = { map = 1949, x = 51.8, y = 58.3 }, note = "Tilbage til Rexxar." },
        }},
        { label = "Mok'Nathal Village og Rexxar", elements = {
                { kind = "accept", quest = 10860, title = "Mok'Nathal Treats",
                  coords = { map = 1949, x = 76.1, y = 60.3 }, note = "Fra Matron Varah - Mok'Nathal-lækkerier." },
        }},
        { label = "Mok'Nathal Village og Rexxar", elements = {
                { kind = "do", quest = 10860, title = "Mok'Nathal Treats",
                  coords = { map = 1949, x = 72.0, y = 62.0 }, note = "Jag dyr til Mok'Nathal Treats." },
        }},
        { label = "Mok'Nathal Village og Rexxar", elements = {
                { kind = "turnin", quest = 10860, title = "Mok'Nathal Treats",
                  coords = { map = 1949, x = 76.1, y = 60.3 }, note = "Aflever hos Matron Varah." },
                { kind = "accept", quest = 10618, title = "The Softest Wings",
                  coords = { map = 1949, x = 75.8, y = 61.5 }, note = "Fra Silmara i Mok'Nathal Village." },
                { kind = "accept", quest = 10617, title = "Silkwing Cocoons",
                  coords = { map = 1949, x = 75.9, y = 61.4 }, note = "Fra Taerek i Mok'Nathal Village." },
        }},
        { label = "Mok'Nathal Village og Rexxar", elements = {
                { kind = "do", quest = 10618, title = "The Softest Wings",
                  coords = { map = 1949, x = 74.1, y = 70.1 }, note = "Saml de blødeste silkwing-vinger syd for landsbyen." },
                { kind = "do", quest = 10617, title = "Silkwing Cocoons",
                  coords = { map = 1949, x = 74.3, y = 70.9 }, note = "Saml Silkwing Cocoons syd for landsbyen." },
        }},
        { label = "Mok'Nathal Village og Rexxar", elements = {
                { kind = "turnin", quest = 10618, title = "The Softest Wings",
                  coords = { map = 1949, x = 75.8, y = 61.5 }, note = "Aflever hos Silmara." },
                { kind = "turnin", quest = 10617, title = "Silkwing Cocoons",
                  coords = { map = 1949, x = 75.9, y = 61.4 }, note = "Aflever hos Taerek." },
        }},
        { label = "Evergrove", elements = {
                { kind = "travel", coords = { map = 1949, x = 62.3, y = 40.1 }, radius = 60,
                  text = "Evergrove", note = "Flyv/løb nordpå til druidernes lejr Evergrove (flight point)." },
        }},
        { label = "Evergrove", elements = {
                { kind = "accept", quest = 10682, title = "A Time for Negotiation...",
                  coords = { map = 1949, x = 62.0, y = 39.5 }, note = "Fra Tree Warden Chawn." },
                { kind = "accept", quest = 10753, title = "Culling the Wild",
                  coords = { map = 1949, x = 62.6, y = 38.3 }, note = "Fra Faradrella." },
        }},
        { label = "Evergrove", elements = {
                { kind = "do", quest = 10682, title = "A Time for Negotiation...",
                  coords = { map = 1949, x = 58.0, y = 42.0 }, note = "Forhandl/dræb ved Bloodmaul-lejrene omkring Evergrove." },
        }},
        { label = "Evergrove", elements = {
                { kind = "do", quest = 10753, title = "Culling the Wild",
                  coords = { map = 1949, x = 60.0, y = 35.0 }, note = "Kontrollér bestanden af nether drakes." },
        }},
        { label = "Evergrove", elements = {
                { kind = "turnin", quest = 10682, title = "A Time for Negotiation...",
                  coords = { map = 1949, x = 62.0, y = 39.5 }, note = "Aflever hos Tree Warden Chawn." },
                { kind = "turnin", quest = 10753, title = "Culling the Wild",
                  coords = { map = 1949, x = 62.6, y = 38.3 }, note = "Aflever hos Faradrella." },
                { kind = "accept", quest = 10819, title = "Felsworn Gas Mask",
                  coords = { map = 1949, x = 62.3, y = 40.1 }, note = "Fra Wildlord Antelarion - Death's Door-kæden." },
        }},
        { label = "Evergrove", elements = {
                { kind = "do", quest = 10819, title = "Felsworn Gas Mask",
                  coords = { map = 1949, x = 73.0, y = 40.0 }, note = "Saml en Felsworn Gas Mask ved Death's Door (syd)." },
                { kind = "turnin", quest = 10819, title = "Felsworn Gas Mask",
                  coords = { map = 1949, x = 73.3, y = 40.0 }, note = "Aflever ved Legion Communicator." },
                { kind = "accept", quest = 10820, title = "Deceive thy Enemy",
                  coords = { map = 1949, x = 73.3, y = 40.0 }, note = "Fra Legion Communicator." },
                { kind = "do", quest = 10820, title = "Deceive thy Enemy",
                  coords = { map = 1949, x = 73.3, y = 40.0 }, note = "Brug kommunikatoren til at narre Legionen." },
                { kind = "turnin", quest = 10820, title = "Deceive thy Enemy",
                  coords = { map = 1949, x = 73.3, y = 40.0 }, note = "Aflever hos Wildlord Antelarion." },
        }},
        { label = "Ekstra: Bladespire kegger & Thunderspike (valgfri)", elements = {
                { kind = "note", coords = { map = 1949, x = 45.0, y = 72.3 }, text = "Disse quests er valgfri",
                  note = "God XP hvis du mangler op til level 68. Spring over efter behov." },
        }},
        { label = "Ekstra: Bladespire kegger & Thunderspike (valgfri)", elements = {
                { kind = "accept", quest = 10542, title = "They Stole Me Hookah and Me Brews!",
                  coords = { map = 1949, x = 45.0, y = 72.3 }, note = "Fra T'chali the Witch Doctor (sydvest, ved Bladespire)." },
        }},
        { label = "Ekstra: Bladespire kegger & Thunderspike (valgfri)", elements = {
                { kind = "do", quest = 10542, title = "They Stole Me Hookah and Me Brews!",
                  coords = { map = 1949, x = 47.3, y = 69.3 }, note = "Skaf hookah og brews tilbage." },
        }},
        { label = "Ekstra: Bladespire kegger & Thunderspike (valgfri)", elements = {
                { kind = "turnin", quest = 10542, title = "They Stole Me Hookah and Me Brews!",
                  coords = { map = 1949, x = 45.0, y = 72.3 }, note = "Aflever hos T'chali the Witch Doctor." },
                { kind = "accept", quest = 10545, title = "Bladespire Kegger",
                  coords = { map = 1949, x = 45.0, y = 72.3 }, note = "Fra T'chali." },
                { kind = "do", quest = 10545, title = "Bladespire Kegger",
                  coords = { map = 1949, x = 45.0, y = 72.3 }, note = "Forgift Bladespire-ogrernes øl (Bladespire Kegger)." },
                { kind = "turnin", quest = 10545, title = "Bladespire Kegger",
                  coords = { map = 1949, x = 45.0, y = 72.3 }, note = "Aflever hos T'chali the Witch Doctor." },
                { kind = "accept", quest = 10543, title = "Grimnok and Korgaah, I Am For You!",
                  coords = { map = 1949, x = 45.0, y = 72.3 }, note = "Fra T'chali." },
        }},
        { label = "Ekstra: Bladespire kegger & Thunderspike (valgfri)", elements = {
                { kind = "do", quest = 10543, title = "Grimnok and Korgaah, I Am For You!",
                  coords = { map = 1949, x = 44.4, y = 63.7 }, note = "Dræb Grimnok og Korgaah." },
        }},
        { label = "Ekstra: Bladespire kegger & Thunderspike (valgfri)", elements = {
                { kind = "turnin", quest = 10543, title = "Grimnok and Korgaah, I Am For You!",
                  coords = { map = 1949, x = 45.0, y = 72.3 }, note = "Aflever hos T'chali the Witch Doctor." },
        }},
        { label = "Ekstra: Bladespire kegger & Thunderspike (valgfri)", elements = {
                { kind = "accept", quest = 10525, title = "Vision Guide",
                  coords = { map = 1949, x = 52.8, y = 59.0 }, note = "Fra Rokgah Bloodgrip ved Thunderlord Stronghold." },
                { kind = "do", quest = 10525, title = "Vision Guide",
                  coords = { map = 1949, x = 52.8, y = 59.0 }, note = "Følg visionens vejledning." },
                { kind = "turnin", quest = 10525, title = "Vision Guide",
                  coords = { map = 1949, x = 52.8, y = 59.0 }, note = "Aflever hos Rokgah Bloodgrip." },
                { kind = "accept", quest = 10526, title = "The Thunderspike",
                  coords = { map = 1949, x = 52.8, y = 59.0 }, note = "Fra Rokgah Bloodgrip." },
        }},
        { label = "Ekstra: Bladespire kegger & Thunderspike (valgfri)", elements = {
                { kind = "do", quest = 10526, title = "The Thunderspike",
                  coords = { map = 1949, x = 39.8, y = 85.5 }, note = "Placér Thunderspike i Circle of Blood." },
        }},
        { label = "Ekstra: Bladespire kegger & Thunderspike (valgfri)", elements = {
                { kind = "turnin", quest = 10526, title = "The Thunderspike",
                  coords = { map = 1949, x = 52.8, y = 59.0 }, note = "Aflever hos Rokgah Bloodgrip." },
        }},
        { label = "Ekstra: Mok'Nathal ånde-kæde (valgfri)", elements = {
                { kind = "accept", quest = 10851, title = "The Totems of My Enemy",
                  coords = { map = 1949, x = 74.9, y = 60.5 }, note = "Fra Spiritcaller Dohgar i Mok'Nathal Village." },
        }},
        { label = "Ekstra: Mok'Nathal ånde-kæde (valgfri)", elements = {
                { kind = "do", quest = 10851, title = "The Totems of My Enemy",
                  coords = { map = 1949, x = 58.0, y = 57.7 }, note = "Ødelæg fjendens totems." },
        }},
        { label = "Ekstra: Mok'Nathal ånde-kæde (valgfri)", elements = {
                { kind = "turnin", quest = 10851, title = "The Totems of My Enemy",
                  coords = { map = 1949, x = 74.9, y = 60.5 }, note = "Aflever hos Spiritcaller Dohgar." },
                { kind = "accept", quest = 10853, title = "Spirit Calling",
                  coords = { map = 1949, x = 74.9, y = 60.5 }, note = "Fra Spiritcaller Dohgar." },
        }},
        { label = "Ekstra: Mok'Nathal ånde-kæde (valgfri)", elements = {
                { kind = "do", quest = 10853, title = "Spirit Calling",
                  coords = { map = 1949, x = 62.6, y = 76.2 }, note = "Kald ånderne." },
        }},
        { label = "Ekstra: Mok'Nathal ånde-kæde (valgfri)", elements = {
                { kind = "turnin", quest = 10853, title = "Spirit Calling",
                  coords = { map = 1949, x = 74.9, y = 60.5 }, note = "Aflever hos Spiritcaller Dohgar." },
                { kind = "accept", quest = 10859, title = "Gather the Orbs",
                  coords = { map = 1949, x = 74.9, y = 60.5 }, note = "Fra Spiritcaller Dohgar." },
                { kind = "do", quest = 10859, title = "Gather the Orbs",
                  coords = { map = 1949, x = 74.9, y = 60.5 }, note = "Saml ånde-orbs." },
                { kind = "turnin", quest = 10859, title = "Gather the Orbs",
                  coords = { map = 1949, x = 74.9, y = 60.5 }, note = "Aflever hos Spiritcaller Dohgar." },
        }},
        { label = "Valgfri: Gruuls sønner", elements = {
                { kind = "note", coords = { map = 1949, x = 53.3, y = 41.2 }, text = "Baron Sablemane-kæden",
                  note = "Valgfrit: Baron Sablemanes kæde mod Gruuls sønner (Grulloc, Gorgrom m.fl.) giver stor XP og fører op mod Gruul's Lair - enkelte dele kræver en gruppe." },
        }},
        { label = "Videre", elements = {
                { kind = "ding", level = 68, note = "Du skal være level 68. Mangler du XP: gør de valgfri kæder ovenfor færdige, eller grind Bloodmaul-ogrer (45,62) indtil du dinger." },
        }},
        { label = "Videre", elements = {
                { kind = "travel", coords = { map = 1953, x = 32.7, y = 65.0 }, radius = 100,
                  text = "Mod Netherstorm", note = "Følg vejen nordøst over broen til Netherstorm; første stop er goblin-byen Area 52. Qeasy skifter automatisk rute." },
        }},
    },
})
