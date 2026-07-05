#!/usr/bin/env python3
"""Smoke test for Qeasy (finkornede steps + config): indlæser hele addonet i
en rigtig Lua-runtime med stubbet WoW-API og simulerer en spiller.

Kørsel:  pip install lupa && python3 tests/test_qeasy.py
"""
import os
import lupa

ADDON_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
lua = lupa.LuaRuntime()

STUBS = r"""
math.atan2 = math.atan2 or function(y, x) return math.atan(y, x) end
PRINTED = {}
print = function(...)
    local parts = {}
    for i = 1, select('#', ...) do parts[#parts+1] = tostring(select(i, ...)) end
    PRINTED[#PRINTED+1] = table.concat(parts, ' ')
end
local function autostub(t)
    setmetatable(t, { __index = function(tbl, k)
        if type(k) ~= 'string' or not k:match('^%u') then return nil end
        local f = function(self, ...) rawset(tbl, '_' .. k, { ... }) end
        rawset(tbl, k, f); return f
    end })
    return t
end
function CreateFrame(ftype, name, parent, template)
    local f = { scripts = {}, _w = 200, _h = 100 }
    function f:SetScript(k, fn) self.scripts[k] = fn end
    function f:GetScript(k) return self.scripts[k] end
    function f:RegisterEvent() end
    function f:UnregisterEvent() end
    function f:SetSize(w, h) self._w, self._h = w, h end
    function f:SetWidth(w) self._w = w end
    function f:SetHeight(h) self._h = h end
    function f:GetWidth() return self._w end
    function f:GetHeight() return self._h end
    function f:GetPoint() return 'CENTER', nil, nil, 0, 0 end
    function f:Show() rawset(f, 'shown', true) end
    function f:Hide() rawset(f, 'shown', false) end
    function f:IsShown() return f.shown end
    function f:GetChecked() return f._checked end
    function f:SetChecked(v) rawset(f, '_checked', v) end
    function f:CreateFontString() return autostub({ GetStringHeight=function() return 12 end }) end
    function f:CreateTexture() return autostub({}) end
    autostub(f)
    if name then _G[name] = f end
    return f
end
UIParent = CreateFrame('Frame', 'UIParent')
BackdropTemplateMixin = nil
SlashCmdList = {}
TIMERS = {}
C_Timer = { After = function(d, fn) TIMERS[#TIMERS+1] = fn end }
function FlushTimers()
    for _ = 1, 25 do
        if #TIMERS == 0 then return end
        local batch = TIMERS; TIMERS = {}
        for _, fn in ipairs(batch) do fn() end
    end
end
PSTATE = { map = 1944, x = 0.50, y = 0.50, facing = 0, faction = 'Horde', level = 58 }
function CreateVector2D(x, y) return { x = x, y = y, GetXY = function(s) return s.x, s.y end } end
C_Map = {
    GetBestMapForUnit = function() return PSTATE.map end,
    GetPlayerMapPosition = function() return CreateVector2D(PSTATE.x, PSTATE.y) end,
    GetWorldPosFromMapPos = function(map, vec)
        local continent = (map == 1419) and 0 or 1
        return continent, { x = -vec.y * 10000, y = -vec.x * 10000 }
    end,
}
QLOG = {}; FLAGGED = {}
function GetNumQuestLogEntries() return #QLOG end
function GetQuestLogTitle(i)
    local q = QLOG[i]; if not q then return nil end
    if q.header then return q.title, 0, nil, true, false, nil, nil, nil end
    return q.title, q.level or 60, nil, false, false, q.complete and 1 or 0, nil, q.questID
end
function GetNumQuestLeaderBoards(i)
    local q = QLOG[i]; return (q and q.objectives) and #q.objectives or 0
end
function GetQuestLogLeaderBoard(j, i)
    local q = QLOG[i]; local o = q and q.objectives and q.objectives[j]
    if not o then return nil end
    return o.text, 'monster', o.done and true or false
end
function GetQuestDifficultyColor(level) return { r = 1, g = 1, b = 0 } end
C_QuestLog = { IsQuestFlaggedCompleted = function(id) return FLAGGED[id] or false end }
function UnitFactionGroup() return PSTATE.faction end
function UnitLevel() return PSTATE.level end
function UnitName(u) return PSTATE.unitName end
function GetPlayerFacing() return PSTATE.facing end
function IsShiftKeyDown() return PSTATE.shift end
function IsControlKeyDown() return PSTATE.ctrl end
function GetAddOnMetadata() return '0.15.2' end
-- Quest-item-knap (secure) + kamp-gate
function InCombatLockdown() return PSTATE.combat end
function GetQuestLogSpecialItemInfo(i)
    local q = QLOG[i]
    if q and q.item then return q.item.link, q.item.icon, q.item.charges or 1 end
    return nil
end
function GetQuestLogSpecialItemCooldown() return 0, 0, 0 end
-- Party-comms + quest-links (Questie-agtigt)
function wipe(t) for k in pairs(t) do t[k] = nil end return t end
function GetTime() return PSTATE.time or 0 end
function IsInGroup() return PSTATE.inGroup end
function IsInRaid() return false end
function Ambiguate(name) return name end
SENT = {}
C_ChatInfo = {
    RegisterAddonMessagePrefix = function() end,
    SendAddonMessage = function(prefix, msg, chan)
        SENT[#SENT+1] = { prefix = prefix, msg = msg, chan = chan }
    end,
}
strsplit = function(sep, s)
    local out = {}
    for part in tostring(s):gmatch('[^' .. sep .. ']+') do out[#out+1] = part end
    return table.unpack(out)
end
EDITBOX = { _text = '' }
function EDITBOX:IsShown() return true end
function EDITBOX:Insert(s) self._text = self._text .. s end
function EDITBOX:SetFocus() end
function EDITBOX:Show() end
function ChatEdit_ChooseBoxForSend() return EDITBOX end
function ChatEdit_ActivateChat() end
DEFAULT_CHAT_FRAME = { AddMessage = function() end }
NUM_CHAT_WINDOWS = 1
hooksecurefunc = function() end
GameTooltip = { HookScript = function() end, GetUnit = function() return nil end,
                SetOwner = function() end, AddLine = function() end,
                ClearLines = function() end, AddDoubleLine = function() end,
                SetHyperlink = function() end,
                Show = function() end, Hide = function() end }
ChatFrame1 = CreateFrame('Frame', 'ChatFrame1')
Minimap = CreateFrame('Frame', 'Minimap')
function Minimap:GetZoom() return 3 end
GetCVar = function() return '0' end
-- WorldMapFrame udeladt (nil) -> kort-pin-koden skal degradere pænt.
"""
lua.execute(STUBS)
g = lua.globals()

ns = lua.eval("{}")
for f in ["Locale.lua", "Engine.lua", "Arrow.lua", "Guide.lua",
          "QuestLog.lua", "ObjectiveTracker.lua", "Tooltips.lua",
          "Comms.lua", "Links.lua",
          "Data/OutlandQuests.lua", "Data/OutlandFlightMasters.lua",
          "Map.lua", "ItemButton.lua", "Config.lua",
          "Routes/HellfirePeninsula.lua", "Routes/Zangarmarsh.lua",
          "Routes/TerokkarForest.lua", "Routes/Nagrand.lua",
          "Routes/BladesEdge.lua", "Routes/Netherstorm.lua",
          "Routes/ShadowmoonValley.lua", "Core.lua"]:
    src = open(os.path.join(ADDON_DIR, f), encoding="utf-8").read()
    lua.eval("function(s,n) return assert(load(s,'@'..n)) end")(src, f)("Qeasy", ns)

fire = lua.eval("function(e,a,b,c,d) QeasyEngineFrame.scripts.OnEvent(QeasyEngineFrame,e,a,b,c,d) end")
flush = g.FlushTimers
Q = ns.Q

failures = []
def check(desc, cond):
    print(("PASS " if cond else "FAIL ") + desc)
    if not cond: failures.append(desc)

def elems(step):
    return list(step.elements.values())

def find_el(route, kind, title):
    for step in list(route.steps.values()):
        for el in elems(step):
            if el.kind == kind and el.q and el.q.title == title:
                return step, el
    return None, None

# ---- startup ----
fire("ADDON_LOADED", "Qeasy"); fire("PLAYER_ENTERING_WORLD"); flush()
check("rute auto-valgt = hellfire-horde", Q.char.activeRoute == "hellfire-horde")
check("7 ruter registreret", len(list(Q.routeOrder.values())) == 7)
check("aktuelt step = 1", Q.current == 1)

# ---- datavalidering + step-granularitet ----
KNOWN = {1419,1944,1946,1948,1949,1951,1952,1953}
KINDS = {"accept","turnin","do","complete","travel","fly","hearth","train",
         "buy","vendor","repair","deliver","note","ding","grind","rep"}
problems = []
keys = list(Q.routeOrder.values())
total_steps = 0
for key in keys:
    r = Q.routes[key]
    total_steps += len(list(r.steps.values()))
    if r.next and r.next not in keys:
        problems.append(f"{key}: next '{r.next}' mangler")
    for step in list(r.steps.values()):
        if not elems(step):
            problems.append(f"{key}: tomt step")
        for el in elems(step):
            if el.kind not in KINDS:
                problems.append(f"{key}: ukendt kind {el.kind}")
            if el.coords and el.coords.map not in KNOWN:
                problems.append(f"{key}: ukendt map {el.coords.map}")
            if el.kind in ("accept","turnin","do") and not (el.q and el.q.title):
                problems.append(f"{key}: quest-element uden titel")
check("rutedata valide: " + ("; ".join(problems) or "ok"), not problems)
check(f"mange små steps (i alt {total_steps} > 180)", total_steps > 180)

route = Q.routes["hellfire-horde"]
check("hellfire opdelt i mange steps (>40)", len(list(route.steps.values())) > 40)

# ---- step 1 = travel til Dark Portal ----
step1 = route.steps[1]
e1 = elems(step1)
check("step 1 = ét travel-element", len(e1) == 1 and e1[0].kind == "travel")

Q.DoRefresh(Q)
pick = ns.Arrow.PickTarget(ns.Arrow)
check("arrow peger på travel-elementet", pick and pick.el.kind == "travel")

lua.execute("PSTATE.map=1419; PSTATE.x=0.552; PSTATE.y=0.537")
ns.Arrow.UpdateTarget(ns.Arrow)
g.QeasyArrowFrame.scripts.OnUpdate(g.QeasyArrowFrame, 0.1)
flush()
check("travel auto-fuldført -> avancerer forbi step 1", Q.current and Q.current > 1)

# ---- accept-element (i et senere step) ----
sAcc, elAcc = find_el(route, "accept", "Through the Dark Portal")
check("accept-element for 9407 findes i en gruppe", elAcc is not None)
lua.execute("QLOG[#QLOG+1] = { title='Through the Dark Portal', questID=9407 }")
fire("QUEST_ACCEPTED", 1, 9407); fire("QUEST_LOG_UPDATE"); flush()
check("accept-element fuldført efter accept", Q.IsElementDone(Q, route, sAcc, elAcc))

sTin, elTin = find_el(route, "turnin", "Through the Dark Portal")
lua.execute("QLOG={}; FLAGGED[9407]=true")
fire("QUEST_TURNED_IN", 9407); flush()
check("turnin-element fuldført efter aflevering", Q.IsElementDone(Q, route, sTin, elTin))

# ---- læring ----
lua.execute("QLOG[#QLOG+1] = { title='Journey to Thrallmar', questID=99999 }")
fire("QUEST_ACCEPTED", 1, 99999); flush()
check("lærte id 99999 for 'Journey to Thrallmar'",
      g.QeasyDB.learned.ids["Journey to Thrallmar"] == 99999)

# ---- skip/back ----
before = Q.current
Q.SkipStep(Q, before); flush()
check("SkipStep avancerer", Q.current != before)
Q.Back(Q); flush()
check("Back fortryder skip", Q.current == before)

# ---- arrow nærmeste-mål ----
lua.execute("PSTATE.map=1944; PSTATE.x=0.553; PSTATE.y=0.365")
Q.DoRefresh(Q)
pick = ns.Arrow.PickTarget(ns.Arrow)
check("arrow finder et ufærdigt element", pick is not None and pick.el is not None)

# ---- config-vindue ----
ns.Config.Open(ns.Config)
check("config-frame synlig efter Open", g.QeasyConfigFrame.shown == True)
ns.Config.Refresh(ns.Config)  # må ikke fejle
check("guide-frame synlig", g.QeasyGuideFrame.shown == True)

# ---- fuldfør rute -> auto-skift ----
Q.SetActiveRoute(Q, "netherstorm-horde"); flush()
nr = Q.routes["netherstorm-horde"]
for i in range(1, len(list(nr.steps.values()))+1):
    Q.SkipStep(Q, i)
flush()
check("fuldført netherstorm -> auto-skift til shadowmoon",
      Q.char.activeRoute == "shadowmoon-horde")

# ---- Questie-agtig quest-tracker + tooltips ----
lua.execute("""
QLOG = {
  { header = true, title = 'Terokkar Forest' },
  { title = 'Kill the Shadow Council!', questID = 10043, level = 65,
    objectives = { { text = 'Shadowy Executioner slain: 4/10', done = false } } },
  { title = 'The Outcast\\'s Plight', questID = 99001, level = 65, complete = false,
    objectives = { { text = 'Arakkoa Feather: 28/30', done = false } } },
  { header = true, title = 'Nagrand' },
  { title = 'Because Kilrath is a Coward', questID = 9891, level = 65, complete = true,
    objectives = {} },
}
""")
done, total = ns.QuestLog.Counts(ns.QuestLog)
check("tracker tæller quests (1 færdig / 3 total)", done == 1 and total == 3)
ns.ObjTracker.Update(ns.ObjTracker)
check("quest-tracker synlig", g.QeasyObjectiveTracker.shown == True)

# aktiv quest = første ufærdige (løftes til toppen + fremhæves)
active = ns.ObjTracker.ActiveQuestID(ns.ObjTracker)
check("tracker vælger aktiv quest (10043)", int(active) == 10043)
Q.char.ui.trackerFocus = 99001
check("manuelt fokus vinder (99001)",
      int(ns.ObjTracker.ActiveQuestID(ns.ObjTracker)) == 99001)
Q.char.ui.trackerFocus = None
ns.ObjTracker.Update(ns.ObjTracker)  # må ikke fejle med fremhævet aktiv quest

# ---- quest-links i chat (Questie-agtigt) ----
link = ns.Links.QuestLink(ns.Links, 10043, "Kill the Shadow Council!", 65)
check("quest-link har korrekt format",
      "Hquest:10043:65" in link and "[Kill the Shadow Council!]" in link)
ns.Links.Init(ns.Links)
check("Links:Init hooker ChatFrame1", ns.Links.hooked[g.ChatFrame1] == True)
g.EDITBOX._text = ""
ns.Links.Insert(ns.Links, 10043, "Kill the Shadow Council!", 65)
check("Links:Insert lægger link i editbox", "Hquest:10043:65" in g.EDITBOX._text)

# ---- party quest-sync ('snakke med Questie') ----
lua.execute("PSTATE.unitName='Me'; PSTATE.inGroup=true")
ns.Comms.Init(ns.Comms)
ns.Comms.OnMessage(ns.Comms, "Qeasy", "1S|10043:C;99001:3/30", "PARTY", "Bob")
bob = ns.Comms.party["Bob"]
check("party-comms modtager Bobs quests", bob is not None
      and bob[10043] == "C" and bob[99001] == "3/30")
ns.Comms.OnMessage(ns.Comms, "Qeasy", "1S|10043:C", "PARTY", "Me")
check("party-comms ignorerer sig selv", ns.Comms.party["Me"] is None)
prog = list(ns.Comms.ProgressFor(ns.Comms, 10043).values())
check("ProgressFor: Bob er 'færdig' med 10043",
      len(prog) == 1 and prog[0].name == "Bob" and prog[0].text == "færdig")
lua.execute("PSTATE.inGroup=true; PSTATE.time=100")
ns.Comms.Broadcast(ns.Comms, True)
check("Broadcast sender addon-besked i gruppe", len(list(g.SENT.values())) >= 1)

hits = ns.QuestLog.ObjectivesForName(ns.QuestLog, "Shadowy Executioner")
hitlist = list(hits.values())
check("tooltip matcher mob -> quest ('Kill the Shadow Council!')",
      len(hitlist) == 1 and hitlist[0].title == "Kill the Shadow Council!")
none = list(ns.QuestLog.ObjectivesForName(ns.QuestLog, "Tilfældig Kanin").values())
check("tooltip: ingen match for urelateret mob", len(none) == 0)

# ---- kort/minimap-ikoner (Outland) ----
check("Outland quest-DB indlæst (>500 quests)",
      ns.QuestDB is not None and sum(1 for _ in ns.QuestDB.keys()) > 500)
lua.execute("PSTATE.map=1944; PSTATE.level=70; QLOG={}; FLAGGED={}")
icons = list(ns.Map.IconsForMap(ns.Map, 1944).values())
kinds = set(i.kind for i in icons)
check(f"kort-ikoner for Hellfire (1944): {len(icons)} stk", len(icons) > 20)
check("indeholder giver-ikoner (!)", "giver" in kinds)

# en available giver-quest må ikke længere vises som giver når den er i loggen
some = int(next(i.qid for i in icons if i.kind == "giver"))
title = ns.QuestDB[some].t
lua.eval("function(t,id) QLOG = { { title=t, questID=id } } end")(title, some)
icons2 = list(ns.Map.IconsForMap(ns.Map, 1944).values())
still_giver = any(i.qid == some and i.kind == "giver" for i in icons2)
check("quest i loggen vises ikke længere som available-giver", not still_giver)

# turnin-ikon ('?') for en quest der er complete via objectives (isComplete-flag = nil)
lua.eval("""function()
  QLOG = { { title='Missing Friends', questID=10852, complete=false,
             objectives = { { text='Children Rescued: 12/12', done=true } } } }
end""")()
lua.execute("PSTATE.map=1952; PSTATE.level=70")
mf = [i for i in list(ns.Map.IconsForMap(ns.Map, 1952).values()) if i.qid == 10852]
check("'?' turnin-ikon for complete-via-objectives quest",
      any(i.kind == "turnin" and i.npc == "Ethan" for i in mf))

# flight masters på kortet (Outland)
check("flight master-DB indlæst", ns.FlightMasters is not None)
fms = list(ns.Map.FlightMastersForMap(ns.Map, 1944).values())
check(f"flight masters i Hellfire (1944): {len(fms)} stk", len(fms) >= 3)
check("flight master har navn + kind", all(f.kind == "flightmaster" and f.title for f in fms))

# opdaget/uopdaget flyvemester: alle er ukendte til at starte med
ns.Q.char.knownFlights = lua.eval("{}")
fms = list(ns.Map.FlightMastersForMap(ns.Map, 1944).values())
check("flyvemestre er uopdagede som standard (grønt '!')",
      all(not f.known for f in fms))
# lær den nærmeste ved at 'åbne rejsekortet' oven i Innalia (27.8, 60.0)
lua.execute("PSTATE.map=1944; PSTATE.x=0.278; PSTATE.y=0.600")
ns.Map.LearnFlightsFromTaxi(ns.Map)
fms = list(ns.Map.FlightMastersForMap(ns.Map, 1944).values())
innalia = next(f for f in fms if f.title == "Innalia")
barley = next(f for f in fms if f.title == "Barley")
check("flyvemester lært via rejsekort (Innalia kendt)", innalia.known == True)
check("andre flyvemestre forbliver uopdagede", not barley.known)

# klyngedannelse: Nesingwary-camp givere (samme sted) samles til ét pin
lua.execute("PSTATE.map=1951; PSTATE.level=70; QLOG={}; FLAGGED={}")
nag_lua = ns.Map.IconsForMap(ns.Map, 1951)
nag = list(nag_lua.values())
clusters = list(ns.Map.ClusterIcons(ns.Map, nag_lua).values())
camp = None
for c in clusters:
    ents = list(c.entries.values())
    if c.kind == "giver" and len(ents) >= 3:
        names = set(e.npc for e in ents)
        if "Hemet Nesingwary" in names or "Shado 'Fitz' Farstrider" in names:
            camp = c; break
check("Nesingwary-camp givere samles i ét pin (>=3 quests)", camp is not None)
check("klyngedannelse reducerer antal pins", len(clusters) < len(nag))

# spawn-område: et aktivt dræb-mål (Clefthoof Mastery) har en sky af punkter
lua.eval("""function() QLOG = { { title='Clefthoof Mastery', questID=9789,
  objectives = { { text='Clefthoof slain: 0/10', done=false } } } } end""")()
cleft = [i for i in list(ns.Map.IconsForMap(ns.Map, 1951).values())
         if i.qid == 9789 and i.kind == "objective"]
check("aktivt dræb-mål har spawn-område (oa)",
      len(cleft) == 1 and cleft[0].oa is not None
      and len(list(cleft[0].oa.values())) >= 3)

# minimap-OnUpdate kører uden fejl (nu også med flight masters + klynger)
lua.execute("PSTATE.map=1944; QLOG={}")
ns.Map.Rebuild(ns.Map)
g.QeasyMinimapPins.scripts.OnUpdate(g.QeasyMinimapPins, 0.2)
check("minimap-pins opdaterer uden fejl", True)

# ---- quest-item-knap (fx Living Fire) ----
lua.execute(r"""
QLOG = {
  { title='Blessing of Incineratus', questID=10286,
    item = { link='item:30813', icon='Interface\\Icons\\INV_Torch_01', charges=5 } },
}
""")
ns.ItemBar.Update(ns.ItemBar)
check("item-bar viser knap for quest-item",
      g.QeasyItemBar.shown == True and g.QeasyItemButton1.link == "item:30813")
ns.ItemBar.SetShown(ns.ItemBar, False)
check("item-bar skjules når slået fra", g.QeasyItemBar.shown == False)
ns.ItemBar.SetShown(ns.ItemBar, True)
lua.execute("PSTATE.combat = true; QLOG = {}")
ns.ItemBar.Update(ns.ItemBar)
check("item-bar rører ikke secure-knapper i kamp (udskudt)", ns.ItemBar._pending == True)
lua.execute("PSTATE.combat = false")

# ---- hero-knap: dukker op midt på skærmen når du er tæt på målet ----
lua.execute(r"""
QLOG = {
  { title='Blessing of Incineratus', questID=9805,
    item = { link='|cffffffff|Hitem:30813:0:0:0:0:0:0:0:0|h[Living Fire]|h|r',
             icon='Interface\\Icons\\Spell_Fire_Fire', charges=3 } },
}
PSTATE.map = 1951; PSTATE.x = 0.718; PSTATE.y = 0.523
""")
ns.ItemBar.UpdateHero(ns.ItemBar)
check("hero-knap vises tæt på quest-item-målet", g.QeasyHeroButton.shown == True)
check("hero-knap har rigtigt item (Living Fire)", "Living Fire" in (g.QeasyHeroButton.link or ""))
lua.execute("PSTATE.x = 0.10; PSTATE.y = 0.10")
ns.ItemBar.UpdateHero(ns.ItemBar)
check("hero-knap skjules væk fra målet", g.QeasyHeroButton.shown == False)
lua.execute("PSTATE.x = 0.718; PSTATE.y = 0.523; PSTATE.combat = true")
ns.ItemBar.UpdateHero(ns.ItemBar)
check("hero-knap udskydes i kamp (secure)", ns.ItemBar._heroPending == True)
lua.execute("PSTATE.combat = false")

# ---- slash ----
for cmd in ("list","debug","","config","skip","back","help","tracker",
            "tooltips","mapicons","minimap","party"):
    lua.eval("SlashCmdList['QEASY']")(cmd)

print("\n--- chat (uddrag) ---")
for line in list(g.PRINTED.values())[:5]:
    print("  " + line)
print(f"\n{'ALLE TESTS BESTÅET' if not failures else str(len(failures))+' FEJL: '+'; '.join(failures)}")
raise SystemExit(1 if failures else 0)
