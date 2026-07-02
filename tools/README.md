# Qeasy route-generator

Ruterne i `../Routes/*.lua` er **genereret** ud fra korte planer med
quest-id'er. Rediger ikke `.lua`-filerne i hånden — ret i stedet planerne
her og kør generatoren, så koordinater og titler forbliver konsistente med
kildedataene.

## Datakilde

Titler og koordinater slås op i [pfQuest](https://github.com/shagu/pfQuest)'
åbne TBC-database (MIT-licens, © Eric Mauser / Shagu). Databasen (~130 MB)
er **ikke** committet her.

## Regenerering

```sh
# 1. Hent pfQuest-databasen (kun db-mappen bruges)
git clone --depth 1 https://github.com/shagu/pfQuest tools/pfquest
#    (eller peg PFQUEST_DB på en eksisterende klon)

# 2. Python-afhængighed
pip install lupa

# 3. Generér alle Routes/*.lua
cd tools && python3 plans.py
```

Sæt evt. `PFQUEST_DB=/sti/til/pfQuest/db` hvis klonen ligger et andet sted.

## Filer

| Fil | Ansvar |
|---|---|
| `qdb.py` | Opslag mod pfQuest: titel, quest-giver, aflevering, objective-centroid, kæde-forudsætninger. Mapper klassiske areaID'er til TBC Classic uiMapID'er. |
| `gen_route.py` | `Plan`-byggeren og `.lua`-serialiseringen. Trin: `S` (sektion), `T` (travel), `N` (note), `A`/`D`/`X` (accept/do/turn-in). |
| `plans.py` | Selve ruterne som quest-id-sekvenser. **Rediger her.** |

## Sådan tilføjes/rettes en quest

Find quest-id'et (fx på Wowhead) og indsæt i den relevante zone i
`plans.py`:

```python
p.A(10121, "Dansk note (valgfri).")   # ACCEPT hos quest-giveren
p.D(10121, "Hvad du skal gøre.")       # DO ved objective-området
p.X(10121)                              # TURN-IN hos modtageren
```

Koordinater hentes automatisk. Vil du overstyre et DO-punkt, så giv
`at=(map, x, y)`. Kør `plans.py` igen og commit både `plans.py` og de
opdaterede `Routes/*.lua`.
