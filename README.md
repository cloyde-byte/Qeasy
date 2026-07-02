# Qeasy — Quest Helper til WoW: The Burning Crusade (Anniversary)

Qeasy er et letvægts quest helper-addon til **World of Warcraft: The Burning
Crusade — Anniversary**. Det giver dig det komplette overblik over hvilke
quests du skal tage, i hvilken rækkefølge — med en **GPS-pil** der peger
derhen, hvor du skal løbe (som TomTom), og en **tracker** der viser det
aktuelle trin og de næste par trin.

Ruterne er bygget over anbefalingerne i Wowheads leveling-guides til
Burning Crusade Classic (Rokmans zone-guides) og dækker **Horde**:

| Rute | Zone | Level |
|---|---|---|
| `hellfire-horde` | Hellfire Peninsula | 58–63 |
| `zangarmarsh-horde` | Zangarmarsh | 61–64 |

Flere zoner (Terokkar Forest, Nagrand, …) er planlagt — dataformatet er
klar til dem.

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

## Selvlærende quest-data

Rute-dataene (quest-id'er og koordinater) er *best effort*. Qeasy retter
selv småfejl, mens du spiller:

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
  quest = 10121,                -- quest-id (kan udelades)
  title = "Through the Dark Portal",  -- engelsk titel (skal matche klienten)
  coords = { map = 1944, x = 87.3, y = 52.0 },  -- uiMapID + zone-procenter
  label = "The Stair of Destiny",     -- kort tekst til pilen
  note  = "Dansk hjælpetekst..." },
```

Rettelser til quest-id'er, koordinater og rækkefølge modtages meget gerne
som pull requests — det er én linje pr. rettelse.

## Inspiration

- **TomTom** — GPS-pilens koncept (koden her er skrevet fra bunden).
- **Questie** — idéer til quest-tracking. Der er ikke kopieret kode eller
  data fra andre addons.

## Licens

MIT — se `LICENSE`.
