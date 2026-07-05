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

Qeasy er inspireret af **RestedXP**: Ruten er delt i **mange små steps** —
ét sted, én handling ad gangen, hvor kun handlinger på præcis samme spot
lægges sammen (fx "tag disse 2 quests fra samme NPC"). Så du render ikke
frem og tilbage. Addonet starter automatisk på Horde-karakterer og vælger
ruten ud fra din zone (eller Hellfire fra level 58).

Åbn **indstillingsvinduet** med `/qeasy`, via **Qeasy-knappen på
minimappet** (Waypoint Q-medaljonen — venstreklik åbner, træk flytter),
eller via Blizzards AddOn-menu. Her kan du slå guide, pil, tracker,
tooltips og kort-ikoner til/fra, justere størrelsen, slå automatisk
rutevalg fra og skifte aktiv rute — uden tekstkommandoer.

- **Guide-vinduet** viser det aktuelle step som en liste af handlinger,
  hver med et ikon og et **grønt flueben**, der sættes automatisk, når du
  har gjort den. De næste steps vises nedtonet nedenunder. Træk vinduet
  for at flytte det.
- **Pilen** peger på det **nærmeste ufærdige mål** i det aktuelle step (som
  RestedXP's "Follow the Arrow") og skifter farve grøn→rød efter, om du
  løber rigtigt. Afstand vises i yards. Flyt pilen med **Shift + træk**.
- Under handlingerne står en **hjælpe-tekst** for det, du er i gang med
  (hvor NPC'en står, hvad du skal dræbe/samle osv.).
- Handlinger krydses af **automatisk**: accept, objectives, aflevering,
  rejse (ved ankomst) og level-checkpoints (`ding`). Quests du allerede har
  klaret, springes over.
- `Spring over` fuldfører hele det aktuelle step; `Tilbage` fortryder.

### Ding-garanti og ekstra quests

Hver zone ender med et **`ding`-checkpoint** (fx "Ding 65!"). Det kan
**ikke** passeres, før du faktisk har nået det level — så guiden lover dig
aldrig et level, du ikke har. Før hvert ding ligger en eller flere
**"Ekstra quests (valgfri)"**-sektioner med rigtige quests (med hjælp), så
der er nok XP til at nå målet. Mangler du stadig, fortæller ding-steppet
hvor du bedst grinder de sidste procent. Vil du springe de valgfri quests
over, trykker du bare `Spring over`.

### Trin-typer

Hvert step består af handlinger af disse typer:

| Type | Betydning |
|---|---|
| `accept` / `turnin` / `do` | tag / aflever / udfør en quest |
| `travel` / `fly` | løb/flyv til et sted (auto-flueben ved ankomst) |
| `hearth` / `train` / `vendor` / `buy` | sæt hearthstone, træn spells, handl |
| `ding` / `grind` | level-checkpoint / grind til level N |
| `note` | info/påmindelse (fx en quest-kæde du selv følger) |

### Questie-agtige funktioner

Ud over den guidede rute fungerer Qeasy som et alment quest-addon:

- **Quest-tracker**: et flytbart vindue (Shift + træk) der viser *alle*
  dine aktive quests grupperet efter zone, med objectives og fremgang
  (fx "Arakkoa Feather: 28/30") og farve efter sværhedsgrad. Klik en
  quest-titel for at folde dens objectives sammen. Virker for enhver
  quest — også dem uden for ruten.
- **Mob-tooltips**: peger du på en skabning, viser Qeasy hvilke af dine
  aktive quests den tæller til, og hvor langt du er (fx
  "Kill the Shadow Council! — Shadowy Executioner slain: 4/10").
- **Kort- og minimap-ikoner (kun Outland)**: på verdenskortet og
  minimappet viser Qeasy quest-ikoner ligesom Questie:
  - **!** = en quest du kan tage her (ikke i loggen, ikke klaret, du har
    level og forudsætninger)
  - **?** = en quest i din log der er *færdig* og skal afleveres her
  - grøn prik = et objektiv for en quest du er i gang med
  grøn prik = et objektiv (vises som et lille **pulserende tandhjul**)
  Ikonerne kommer fra en indbygget Outland-quest-database (1162 quests),
  udtrukket fra pfQuest. Hold musen over et kort-ikon for at se questens
  navn og NPC.
- **Flyvemestre (kun Outland)**: alle Horde- og neutrale flyvemestre vises
  med et gryf-ikon på kort og minimap, så du nemt kan finde dem (19 stk,
  med præcise koordinater fra pfQuest).

Alt kan slås til/fra i indstillingsvinduet (eller `/qeasy tracker`,
`/qeasy tooltips`, `/qeasy mapicons`, `/qeasy minimap`). Tracker og
tooltips læses live fra din quest-log; kort-ikonerne bruger den indbyggede
Outland-database.

### Kommandoer

```
/qeasy               åbn/luk indstillingsvinduet
/qeasy help          vis kommandoliste
/qeasy show|hide     vis/skjul guide og pil
/qeasy arrow         vis/skjul kun pilen
/qeasy tracker       vis/skjul quest-trackeren
/qeasy tooltips      slå quest-info i mob-tooltips til/fra
/qeasy mapicons      slå kort-ikoner til/fra (Outland)
/qeasy minimap       slå minimap-ikoner til/fra (Outland)
/qeasy flightmasters slå flyvemester-ikoner til/fra (Outland)
/qeasy skip          spring det aktuelle step over
/qeasy back          fortryd seneste spring/afkrydsning
/qeasy list          vis alle ruter
/qeasy route <navn>  skift rute (fx /qeasy route zangarmarsh-horde)
/qeasy reset         nulstil den aktive rute
/qeasy debug         vis teknisk info om det aktuelle step
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
