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
    local f = { scripts = {} }
    function f:SetScript(k, fn) self.scripts[k] = fn end
    function f:GetScript(k) return self.scripts[k] end
    function f:RegisterEvent() end
    function f:UnregisterEvent() end
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
    return q.title, 60, nil, false, false, q.complete and 1 or 0, nil, q.questID
end
C_QuestLog = { IsQuestFlaggedCompleted = function(id) return FLAGGED[id] or false end }
function UnitFactionGroup() return PSTATE.faction end
function UnitLevel() return PSTATE.level end
function GetPlayerFacing() return PSTATE.facing end
function IsShiftKeyDown() return false end
function GetAddOnMetadata() return '0.5.0' end
"""
lua.execute(STUBS)
g = lua.globals()

ns = lua.eval("{}")
for f in ["Locale.lua", "Engine.lua", "Arrow.lua", "Guide.lua", "Config.lua",
          "Routes/HellfirePeninsula.lua", "Routes/Zangarmarsh.lua",
          "Routes/TerokkarForest.lua", "Routes/Nagrand.lua",
          "Routes/BladesEdge.lua", "Routes/Netherstorm.lua",
          "Routes/ShadowmoonValley.lua", "Core.lua"]:
    src = open(os.path.join(ADDON_DIR, f), encoding="utf-8").read()
    lua.eval("function(s,n) return assert(load(s,'@'..n)) end")(src, f)("Qeasy", ns)

fire = lua.eval("function(e,a,b) QeasyEngineFrame.scripts.OnEvent(QeasyEngineFrame,e,a,b) end")
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

# ---- slash ----
for cmd in ("list","debug","","config","skip","back","help"):
    lua.eval("SlashCmdList['QEASY']")(cmd)

print("\n--- chat (uddrag) ---")
for line in list(g.PRINTED.values())[:5]:
    print("  " + line)
print(f"\n{'ALLE TESTS BESTÅET' if not failures else str(len(failures))+' FEJL: '+'; '.join(failures)}")
raise SystemExit(1 if failures else 0)
