local _, ns = ...
local L = ns.L

-- =========================================================================
-- Qeasy Engine (v2): grupperede trin a la RestedXP.
--
-- En rute er en liste af STEPS (grupper). Hvert step har en liste af
-- ELEMENTS (direktiver), som udføres sammen i én geografisk sløjfe:
--   { kind = "accept"|"turnin"|"do"|"travel"|"fly"|"hearth"|"train"
--            |"buy"|"vendor"|"repair"|"deliver"|"grind"|"ding"|"note",
--     quest = questID, title = "engelsk titel",
--     coords = { map = uiMapID, x = 0-100, y = 0-100 },
--     radius = yards (travel/fly), text = "dansk tekst",
--     level = mållevel (grind/ding), optional = true }
--
-- Guiden viser det aktuelle step med et flueben pr. element; pilen peger
-- på det NÆRMESTE ufærdige element med koordinater. Addonet automatiserer
-- intet gameplay - det viser kun vej og krydser af.
-- =========================================================================

local Q = CreateFrame("Frame", "QeasyEngineFrame")
ns.Q = Q

Q.routes = {}
Q.routeOrder = {}
Q.current = nil        -- index for det aktuelle step
Q.snapshot = { onQuest = {}, byTitle = {} }

-- Element-typer der afsluttes manuelt (flueben / nærheds-check).
local MANUAL = {
    travel = true, fly = true, hearth = true, train = true, buy = true,
    vendor = true, repair = true, deliver = true, note = true, rep = true,
}
-- Element-typer der peger på en quest.
local QUESTY = { accept = true, turnin = true, ["do"] = true, complete = true }

-- ---------------------------------------------------------------------
-- Saved variables
-- ---------------------------------------------------------------------
function Q:InitDB()
    QeasyDB = QeasyDB or {}
    QeasyDB.learned = QeasyDB.learned or {}
    QeasyDB.learned.ids = QeasyDB.learned.ids or {}
    QeasyDB.learned.accept = QeasyDB.learned.accept or {}
    QeasyDB.learned.turnin = QeasyDB.learned.turnin or {}

    QeasyCharDB = QeasyCharDB or {}
    local c = QeasyCharDB
    c.done = c.done or {}          -- [routeKey][stepIndex][elemIndex] = true (manuelle)
    c.skipped = c.skipped or {}    -- [routeKey][stepIndex] = true (helt sprunget over)
    c.history = c.history or {}    -- stak til "Tilbage"
    c.turnedIn = c.turnedIn or {}  -- [questID] = true
    c.ui = c.ui or {}
    if c.ui.guideShown == nil then c.ui.guideShown = true end
    if c.ui.arrowShown == nil then c.ui.arrowShown = true end
    if c.ui.objTrackerShown == nil then c.ui.objTrackerShown = true end
    if c.ui.tooltipsEnabled == nil then c.ui.tooltipsEnabled = true end
    if c.ui.mapIcons == nil then c.ui.mapIcons = true end
    if c.ui.minimapIcons == nil then c.ui.minimapIcons = true end
    if c.ui.minimapButton == nil then c.ui.minimapButton = true end
    if c.ui.minimapButtonAngle == nil then c.ui.minimapButtonAngle = 210 end
    if c.ui.flightMasters == nil then c.ui.flightMasters = true end
    if c.ui.trackerMaxHeight == nil then c.ui.trackerMaxHeight = 460 end
    if c.ui.partyShare == nil then c.ui.partyShare = true end
    if c.ui.itemBar == nil then c.ui.itemBar = true end
    if c.ui.heroButton == nil then c.ui.heroButton = true end
    if c.ui.spawnAreas == nil then c.ui.spawnAreas = true end
    c.knownFlights = c.knownFlights or {}   -- opdagede flyvemestre (per karakter)
    self.db = QeasyDB
    self.char = c
end

-- ---------------------------------------------------------------------
-- Rute-registrering
-- ---------------------------------------------------------------------
function Q:RegisterRoute(route)
    assert(route.key and route.title and route.steps, "Qeasy: ugyldig rute")
    for si, step in ipairs(route.steps) do
        step.index = si
        step.elements = step.elements or {}
        for ei, el in ipairs(step.elements) do
            el.index = ei
            assert(MANUAL[el.kind] or QUESTY[el.kind] or el.kind == "grind" or el.kind == "ding",
                "Qeasy: ugyldig element-type '" .. tostring(el.kind) .. "' i " .. route.key .. " #" .. si)
            if QUESTY[el.kind] and (el.quest or el.title) then
                el.q = { id = el.quest, title = el.title }
            end
        end
    end
    self.routes[route.key] = route
    table.insert(self.routeOrder, route.key)
end

function Q:GetActiveRoute()
    local key = self.char and self.char.activeRoute
    return key and self.routes[key] or nil
end

function Q:SetActiveRoute(key, silent)
    local route = self.routes[key]
    if not route then
        print(string.format(L.ROUTE_UNKNOWN, tostring(key)))
        return
    end
    self.char.activeRoute = key
    self.routeAdvanced = nil
    if not silent then print(string.format(L.ROUTE_ACTIVE, route.title)) end
    self:Refresh()
end

function Q:AutoPickRoute()
    if self.char.activeRoute and self.routes[self.char.activeRoute] then return end
    local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local level = UnitLevel and UnitLevel("player") or 0
    local pick
    if mapID then
        for _, key in ipairs(self.routeOrder) do
            for _, zone in ipairs(self.routes[key].zones or {}) do
                if zone == mapID then pick = key break end
            end
            if pick then break end
        end
    end
    if not pick and level >= 58 then pick = self.routeOrder[1] end
    if pick then self:SetActiveRoute(pick) end
end

-- ---------------------------------------------------------------------
-- Quest-log snapshot
-- ---------------------------------------------------------------------
function Q:ScanQuestLog()
    local onQuest, byTitle = {}, {}
    if GetQuestLogTitle and GetNumQuestLogEntries then
        for i = 1, GetNumQuestLogEntries() do
            local title, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(i)
            if not isHeader and questID and questID > 0 then
                onQuest[questID] = (isComplete == 1) or (isComplete == true)
                if title then byTitle[title] = questID end
            end
        end
    elseif C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo then
        for i = 1, C_QuestLog.GetNumQuestLogEntries() do
            local info = C_QuestLog.GetInfo(i)
            if info and not info.isHeader and info.questID then
                local complete = C_QuestLog.IsComplete and C_QuestLog.IsComplete(info.questID)
                onQuest[info.questID] = complete or false
                if info.title then byTitle[info.title] = info.questID end
            end
        end
    end
    self.snapshot.onQuest = onQuest
    self.snapshot.byTitle = byTitle
end

local function IsFlaggedCompleted(questID)
    if not questID then return false end
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(questID)
    end
    if IsQuestFlaggedCompleted then return IsQuestFlaggedCompleted(questID) end
    return false
end

function Q:QuestCandidates(q)
    local ids = {}
    if q.id then ids[#ids + 1] = q.id end
    local learned = q.title and self.db.learned.ids[q.title]
    if learned and learned ~= q.id then ids[#ids + 1] = learned end
    return ids
end

function Q:IsQuestOn(q)
    for _, id in ipairs(self:QuestCandidates(q)) do
        if self.snapshot.onQuest[id] ~= nil then return true, self.snapshot.onQuest[id] end
    end
    if q.title then
        local id = self.snapshot.byTitle[q.title]
        if id then return true, self.snapshot.onQuest[id] end
    end
    return false, false
end

function Q:IsQuestTurnedIn(q)
    for _, id in ipairs(self:QuestCandidates(q)) do
        if self.char.turnedIn[id] or IsFlaggedCompleted(id) then return true end
    end
    if q.title then
        if self.char.turnedIn[q.title] then return true end
        local id = self.snapshot.byTitle[q.title]
        if id and self.char.turnedIn[id] then return true end
    end
    return false
end

-- ---------------------------------------------------------------------
-- Element- og step-fremdrift
-- ---------------------------------------------------------------------
local function PlayerLevel()
    return UnitLevel and UnitLevel("player") or 0
end

function Q:IsElementDone(route, step, el)
    -- Manuel afkrydsning (og nærheds-auto for travel/fly)
    local d = self.char.done[route.key]
    if d and d[step.index] and d[step.index][el.index] then return true end

    if el.kind == "grind" or el.kind == "ding" then
        return PlayerLevel() >= (el.level or 0)
    end
    if MANUAL[el.kind] then
        return false -- afventer flueben / ankomst
    end

    local q = el.q
    if not q then return false end
    if el.kind == "accept" then
        return self:IsQuestOn(q) or self:IsQuestTurnedIn(q)
    elseif el.kind == "turnin" then
        return self:IsQuestTurnedIn(q)
    else -- do / complete
        if self:IsQuestTurnedIn(q) then return true end
        local on, complete = self:IsQuestOn(q)
        return on and complete
    end
end

function Q:IsStepDone(route, step)
    if self.char.skipped[route.key] and self.char.skipped[route.key][step.index] then
        return true
    end
    -- Alle elementer skal være udført (valgfri er kun kosmetisk: brug
    -- "Spring over" for at forlade et step, du ikke vil lave). Det sikrer
    -- at valgfri/ekstra quests faktisk vises i stedet for at forsvinde.
    for _, el in ipairs(step.elements) do
        if not self:IsElementDone(route, step, el) then
            return false
        end
    end
    return true
end

function Q:CurrentStepIndex()
    local route = self:GetActiveRoute()
    if not route then return nil end
    for i, step in ipairs(route.steps) do
        if not self:IsStepDone(route, step) then return i end
    end
    return nil
end

function Q:GetCurrentStep()
    local route = self:GetActiveRoute()
    if not route or not self.current then return nil end
    return route.steps[self.current]
end

-- Forbedret koordinat for et element (lærte koordinater først).
function Q:ElementTarget(el)
    if not el then return nil end
    local q = el.q
    if q and q.title then
        local learned
        if el.kind == "accept" then learned = self.db.learned.accept[q.title]
        elseif el.kind == "turnin" then learned = self.db.learned.turnin[q.title] end
        if learned then return learned end
    end
    return el.coords
end

-- ---------------------------------------------------------------------
-- Manuel styring: flueben, spring over, tilbage
-- ---------------------------------------------------------------------
function Q:MarkElementDone(stepIndex, elemIndex, silent)
    local route = self:GetActiveRoute()
    if not route then return end
    self.char.done[route.key] = self.char.done[route.key] or {}
    self.char.done[route.key][stepIndex] = self.char.done[route.key][stepIndex] or {}
    if self.char.done[route.key][stepIndex][elemIndex] then return end
    self.char.done[route.key][stepIndex][elemIndex] = true
    table.insert(self.char.history, { kind = "elem", route = route.key, step = stepIndex, elem = elemIndex })
    if not silent then print(L.STEP_SKIPPED) end
    self:Refresh()
end

function Q:SkipStep(index)
    local route = self:GetActiveRoute()
    index = index or self.current
    if not route or not index or not route.steps[index] then return end
    self.char.skipped[route.key] = self.char.skipped[route.key] or {}
    if self.char.skipped[route.key][index] then return end
    self.char.skipped[route.key][index] = true
    table.insert(self.char.history, { kind = "step", route = route.key, step = index })
    print(L.STEP_SKIPPED)
    self:Refresh()
end

function Q:Back()
    local entry = table.remove(self.char.history)
    if not entry then print(L.STEP_NOTHING_BACK) return end
    if entry.kind == "step" then
        local s = self.char.skipped[entry.route]
        if s then s[entry.step] = nil end
    else
        local d = self.char.done[entry.route]
        if d and d[entry.step] then d[entry.step][entry.elem] = nil end
    end
    print(L.STEP_BACK)
    self:Refresh()
end

function Q:ResetRoute()
    local route = self:GetActiveRoute()
    if not route then return end
    self.char.done[route.key] = {}
    self.char.skipped[route.key] = {}
    local kept = {}
    for _, e in ipairs(self.char.history) do
        if e.route ~= route.key then kept[#kept + 1] = e end
    end
    self.char.history = kept
    self.routeAdvanced = nil
    print(L.ROUTE_RESET)
    self:Refresh()
end

-- ---------------------------------------------------------------------
-- Læring
-- ---------------------------------------------------------------------
local function PlayerCoords()
    if not (C_Map and C_Map.GetBestMapForUnit) then return nil end
    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then return nil end
    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then return nil end
    local x, y = pos:GetXY()
    if not x or (x == 0 and y == 0) then return nil end
    return { map = mapID, x = x * 100, y = y * 100 }
end

function Q:FindElementsByTitle(title)
    local route = self:GetActiveRoute()
    if not route or not title then return {} end
    local hits = {}
    for _, step in ipairs(route.steps) do
        for _, el in ipairs(step.elements) do
            if el.q and el.q.title == title then hits[#hits + 1] = el end
        end
    end
    return hits
end

function Q:OnQuestAccepted(questID)
    if not questID or not self:GetActiveRoute() then return end
    C_Timer.After(0.3, function()
        self:ScanQuestLog()
        local title
        for t, id in pairs(self.snapshot.byTitle) do
            if id == questID then title = t break end
        end
        if not title then return end
        for _, el in ipairs(self:FindElementsByTitle(title)) do
            if el.q.id ~= questID and self.db.learned.ids[title] ~= questID then
                self.db.learned.ids[title] = questID
                print(string.format(L.LEARNED_ID, questID, title, tostring(el.q.id)))
            end
            if el.kind == "accept" and not self.db.learned.accept[title] then
                self.db.learned.accept[title] = PlayerCoords()
            end
        end
        self:Refresh()
    end)
end

function Q:OnQuestTurnedIn(questID)
    if not questID then return end
    self.char.turnedIn[questID] = true
    local step = self:GetCurrentStep()
    if step then
        for _, el in ipairs(step.elements) do
            if el.q then
                for _, id in ipairs(self:QuestCandidates(el.q)) do
                    if id == questID and el.q.title then
                        self.char.turnedIn[el.q.title] = true
                        if el.kind == "turnin" and not self.db.learned.turnin[el.q.title] then
                            self.db.learned.turnin[el.q.title] = PlayerCoords()
                        end
                    end
                end
            end
        end
    end
    self:Refresh()
end

-- ---------------------------------------------------------------------
-- Refresh
-- ---------------------------------------------------------------------
local refreshPending = false
function Q:Refresh()
    if refreshPending then return end
    refreshPending = true
    C_Timer.After(0.12, function()
        refreshPending = false
        Q:DoRefresh()
    end)
end

function Q:DoRefresh()
    self:ScanQuestLog()
    local route = self:GetActiveRoute()
    self.current = self:CurrentStepIndex()

    if route and not self.current and not self.routeAdvanced then
        self.routeAdvanced = true
        local nextRoute = route.next and self.routes[route.next]
        if nextRoute then
            print(string.format(L.ROUTE_COMPLETE, string.format(L.ROUTE_NEXT, nextRoute.title)))
            self:SetActiveRoute(route.next, true)
            return
        else
            print(string.format(L.ROUTE_COMPLETE, ""))
        end
    end

    if ns.Guide then ns.Guide:Update() end
    if ns.Arrow then ns.Arrow:UpdateTarget() end
    if ns.ObjTracker then ns.ObjTracker:Update() end
    if ns.Map then ns.Map:Rebuild() end
end
