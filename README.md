# Qeasy — Quest Helper til WoW: The Burning Crusade (Anniversary)

Qeasy er et letvægts quest helper-addon til **World of Warcraft: The Burning
Crusade — Anniversary**. Det giver dig det komplette overblik over hvilke
quests du skal tage, i hvilken rækkefølge — med en **GPS-pil** der peger
derhen, hvor du skal løbe (som TomTom), og en **tracker** der viser det
aktuelle trin og de næste par trin.

Ruternes rækkefølge følger Wowheads leveling-guides til Burning Crusade
Classic, og **hvert quest-id og hver koordinat er verificeret mod
[pfQuest](https://github.com/shagu/pfQuest)-databasen** (se
[Datakilde](#datakilde)). Qeasy dækker **Horde** hele vejen 58 → 70:

| Rute | Zone | Level | Trin |
|---|---|---|---|
| `hellfire-horde` | Hellfire Peninsula | 58–63 | 78 |
| `zangarmarsh-horde` | Zangarmarsh | 61–64 | 50 |
| `terokkar-horde` | Terokkar Forest | 62–65 | 40 |
| `nagrand-horde` | Nagrand | 64–67 | 46 |
| `blades-edge-horde` | Blade's Edge Mountains | 65–68 | 41 |
| `netherstorm-horde` | Netherstorm | 67–69 | 39 |
| `shadowmoon-horde` | Shadowmoon Valley | 67–70 | 38 |

Ruterne hænger sammen i en kæde: Når du fuldfører én rute, skifter Qeasy
automatisk til den næste — hele vejen fra Dark Portal til level 70.

## Ikke en bot

Qeasy automatiserer **ingenting**. Det accepterer eller afleverer aldrig
quests for dig, flytter dig aldrig og trykker aldrig på noget. Det viser
kun *hvor* du skal hen og *hvad* du skal gøre — alle handlinger foretager
du selv. Det holder addonet trygt inden for Blizzards regler.

## Installation

1. Download/klon dette repository.
2. Kopiér mappen ind i din WoW-installation som:
   `World of Warcraft/_classic_/Interface/AddOns/Qeasy`
   (mappen skal hedde `Qeasy` og indeholde `Qeasy.toc`).
3. Genstart spillet eller kør `/reload`.

> **Interface-version:** `Qeasy.toc` er sat til `20505` (TBC 2.5.5). Hvis
> klienten er nyere, kan du enten opdatere tallet i `.toc`-filen eller slå
> "Load out of date AddOns" til i addon-listen.

## Sådan bruges det

Addonet starter automatisk på Horde-karakterer: Det vælger selv ruten ud
fra din zone (eller Hellfire-ruten fra level 58) og viser tracker + pil.

- **Pilen** peger mod målet for det aktuelle trin og skifter farve:
  grøn = du løber den rigtige vej, rød = du vender forkert. Afstanden
  vises i yards. Flyt pilen med **Shift + træk**.
- **Trackeren** viser det aktuelle trin med dansk hjælpetekst og de næste
  par trin. Flyt den ved at trække i den.
- Trin fuldføres **automatisk**: Når du accepterer en quest, gør dens
  objectives færdige eller afleverer den, hopper Qeasy videre til næste
  trin. Rejse-trin fuldføres, når du når frem. Quests du allerede har
  klaret, springes over automatisk.
- `Spring over` / `Tilbage`-knapperne styrer trin manuelt (bruges også
  til info-trin, fx "ryd op i loggen").

### Kommandoer

```
/qeasy               hjælp
/qeasy show|hide     vis/skjul tracker og pil
/qeasy arrow         vis/skjul kun pilen
/qeasy skip          spring det aktuelle trin over
/qeasy back          fortryd seneste manuelle trin
/qeasy list          vis alle ruter
/qeasy route <navn>  skift rute (fx /qeasy route zangarmarsh-horde)
/qeasy reset         nulstil manuelle trin på den aktive rute
/qeasy debug         vis teknisk info om det aktuelle trin
```

## Datakilde

Quest-id'er, engelske titler og koordinater (quest-giver, afleverings-NPC
og objective-områder) er slået op i **[pfQuest](https://github.com/shagu/pfQuest)**'
åbne TBC-database (MIT-licens, © Eric Mauser / Shagu). Selve rækkefølgen
og hub-strukturen følger Wowheads Horde-leveling-guides.

Ruterne genereres fra korte planer med quest-id'er (`tools/plans.py`), der
via et opslagsmodul (`tools/qdb.py` mod pfQuest) udfyldes med titler og
koordinater. Det gør dataene lette at rette og udvide: én linje pr. quest.
Koordinaterne er *centroider* af NPC-/mob-spawns — som regel præcise nok
til pilen, men enkelte objective-punkter er sat manuelt.

> pfQuest-databasen (~130 MB) følger **ikke** med i dette repo. Vil du
> regenerere ruterne, så klon pfQuest og kør `tools/plans.py` (se
> kildehenvisningerne i toppen af hver `Routes/*.lua`).

## Selvlærende quest-data

Ovenpå den verificerede data retter Qeasy stadig selv eventuelle
uoverensstemmelser, mens du spiller:

- Accepterer du en quest, hvis titel matcher et trin, men med et andet
  quest-id end dataene siger, **lærer** Qeasy det rigtige id og bruger det
  fremover (gemmes i `SavedVariables`).
- Første gang du accepterer/afleverer en quest, gemmes din position som
  forbedret koordinat for det trin.

Trin uden quest-id matcher på quest-titlen alene, så ruten virker selv
med huller i dataene.

## Dataformat (bidrag velkomne)

Ruterne ligger i `Routes/*.lua` og består af simple trin:

```lua
{ type = "ACCEPT",              -- ACCEPT | DO | TURNIN | TRAVEL | NOTE
  quest = 9407,                 -- quest-id (kan udelades)
  title = "Through the Dark Portal",  -- engelsk titel (skal matche klienten)
  coords = { map = 1419, x = 55.2, y = 53.7 },  -- uiMapID + zone-procenter
  label = "The Stair of Destiny",     -- kort tekst til pilen
  note  = "Dansk hjælpetekst..." },
```

Rettelser til quest-id'er, koordinater og rækkefølge modtages meget gerne
som pull requests — det er én linje pr. rettelse. Genereringsværktøjerne
ligger i `tools/`.

## Test

`tests/test_qeasy.py` indlæser hele addonet i en rigtig Lua-runtime med
stubbet WoW-API og simulerer en spiller, der følger ruten (fremdrift,
læring, pil, rutekæde). Kør den med:

```
pip install lupa && python3 tests/test_qeasy.py
```

## Inspiration

- **TomTom** — GPS-pilens koncept (koden her er skrevet fra bunden).
- **Questie** — idéer til quest-tracking. Der er ikke kopieret kode eller
  data fra andre addons.

## Licens

MIT — se `LICENSE`.
