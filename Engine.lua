local _, ns = ...
local L = ns.L

-- =========================================================================
-- Qeasy Engine: ruter, trin og fremdrift.
--
-- Et trin (step) har formen:
--   type   = "ACCEPT" | "TURNIN" | "DO" | "TRAVEL" | "NOTE"
--   quest  = quest-id (tal, valgfrit - titel bruges som fallback)
--   title  = quest-titel på engelsk (skal matche klienten)
--   quests = { {id=, title=}, ... } for trin der dækker flere quests
--   coords = { map=uiMapID, x=0-100, y=0-100 }  (mål for GPS-pilen)
--   label  = kort stednavn til pilen
--   note   = dansk hjælpetekst
--   radius = "fremme"-radius i yards for TRAVEL-trin (standard 40)
--   optional = true for valgfri trin
--
-- Addonet automatiserer INTET gameplay: det accepterer/afleverer aldrig
-- quests selv og flytter aldrig spilleren. Det viser kun vej.
-- =========================================================================

local Q = CreateFrame("Frame", "QeasyEngineFrame")
ns.Q = Q

Q.routes = {}
Q.routeOrder = {}
Q.current = nil        -- index for det aktuelle trin
Q.snapshot = { onQuest = {}, byTitle = {} }

-- ---------------------------------------------------------------------
-- Saved variables (initialiseres i Core.lua ved ADDON_LOADED)
-- ---------------------------------------------------------------------
function Q:InitDB()
    QeasyDB = QeasyDB or {}
    QeasyDB.learned = QeasyDB.learned or {}
    QeasyDB.learned.ids = QeasyDB.learned.ids or {}       -- [titel] = quest-id
    QeasyDB.learned.accept = QeasyDB.learned.accept or {} -- [titel] = {map,x,y}
    QeasyDB.learned.turnin = QeasyDB.learned.turnin or {} -- [titel] = {map,x,y}

    QeasyCharDB = QeasyCharDB or {}
    local c = QeasyCharDB
    c.done = c.done or {}          -- [routeKey][stepIndex] = true (manuelle/TRAVEL-trin)
    c.history = c.history or {}    -- stak af manuelle markeringer, til "Tilbage"
    c.turnedIn = c.turnedIn or {}  -- [questID] = true (lokal cache af afleveringer)
    c.ui = c.ui or {}
    if c.ui.trackerShown == nil then c.ui.trackerShown = true end
    if c.ui.arrowShown == nil then c.ui.arrowShown = true end
    self.db = QeasyDB
    self.char = c
end

-- ---------------------------------------------------------------------
-- Rute-registrering
-- ---------------------------------------------------------------------
local VALID_TYPES = { ACCEPT = true, TURNIN = true, DO = true, TRAVEL = true, NOTE = true }

function Q:RegisterRoute(route)
    assert(route.key and route.title and route.steps, "Qeasy: ugyldig rute")
    for i, step in ipairs(route.steps) do
        assert(VALID_TYPES[step.type], "Qeasy: ugyldig trin-type i " .. route.key .. " #" .. i)
        step.index = i
        -- Normalisér quest/quests til en fælles liste
        if not step.quests then
            if step.quest or step.title then
                step.quests = { { id = step.quest, title = step.title } }
            else
                step.quests = {}
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
    if not silent then
        print(string.format(L.ROUTE_ACTIVE, route.title))
    end
    self:Refresh()
end

-- Vælg automatisk en rute ud fra spillerens zone (kun hvis ingen er aktiv).
function Q:AutoPickRoute()
    if self.char.activeRoute and self.routes[self.char.activeRoute] then return end
    local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local level = UnitLevel and UnitLevel("player") or 0
    local pick
    if mapID then
        for _, key in ipairs(self.routeOrder) do
            local route = self.routes[key]
            for _, zone in ipairs(route.zones or {}) do
                if zone == mapID then pick = key break end
            end
            if pick then break end
        end
    end
    if not pick and level >= 58 then
        pick = self.routeOrder[1]
    end
    if pick then
        self:SetActiveRoute(pick)
    end
end

-- ---------------------------------------------------------------------
-- Quest-log snapshot (klassisk API med fallback til moderne C_QuestLog)
-- ---------------------------------------------------------------------
function Q:ScanQuestLog()
    local onQuest, byTitle = {}, {}
    if GetQuestLogTitle and GetNumQuestLogEntries then
        local numEntries = GetNumQuestLogEntries()
        for i = 1, numEntries do
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
    if IsQuestFlaggedCompleted then
        return IsQuestFlaggedCompleted(questID)
    end
    return false
end

-- Kandidat-id'er for en quest-definition: datafilens id + evt. lært id.
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
        local id = self.snapshot.byTitle[q.title]
        if id and self.char.turnedIn[id] then return true end
        if self.char.turnedIn[q.title] then return true end
    end
    return false
end

-- ---------------------------------------------------------------------
-- Trin-fremdrift
-- ---------------------------------------------------------------------
function Q:IsStepDone(route, step)
    local done = self.char.done[route.key]
    if done and done[step.index] then return true end

    local t = step.type
    if t == "TRAVEL" or t == "NOTE" then
        return false -- kun manuel markering / nærheds-check
    end

    if #step.quests == 0 then return false end
    for _, q in ipairs(step.quests) do
        if t == "ACCEPT" then
            local on = self:IsQuestOn(q)
            if not on and not self:IsQuestTurnedIn(q) then return false end
        elseif t == "TURNIN" then
            if not self:IsQuestTurnedIn(q) then return false end
        else -- DO
            if not self:IsQuestTurnedIn(q) then
                local on, complete = self:IsQuestOn(q)
                if not (on and complete) then return false end
            end
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
    return nil -- ruten er fuldført
end

function Q:GetCurrentStep()
    local route = self:GetActiveRoute()
    if not route or not self.current then return nil end
    return route.steps[self.current]
end

-- Mål-koordinater for et trin, med lærte koordinater som førsteprioritet.
function Q:GetStepTarget(step)
    if not step then return nil end
    local q = step.quests[1]
    if q and q.title then
        local learned
        if step.type == "ACCEPT" then
            learned = self.db.learned.accept[q.title]
        elseif step.type == "TURNIN" then
            learned = self.db.learned.turnin[q.title]
        end
        if learned then return learned end
    end
    return step.coords
end

-- ---------------------------------------------------------------------
-- Manuelle markeringer: spring over / tilbage / nulstil
-- ---------------------------------------------------------------------
function Q:MarkStepDone(index, silent)
    local route = self:GetActiveRoute()
    if not route or not route.steps[index] then return end
    self.char.done[route.key] = self.char.done[route.key] or {}
    if self.char.done[route.key][index] then return end
    self.char.done[route.key][index] = true
    table.insert(self.char.history, { route = route.key, index = index })
    if not silent then print(L.STEP_SKIPPED) end
    self:Refresh()
end

function Q:SkipCurrent()
    if self.current then self:MarkStepDone(self.current) end
end

function Q:Back()
    local entry = table.remove(self.char.history)
    if not entry then
        print(L.STEP_NOTHING_BACK)
        return
    end
    local done = self.char.done[entry.route]
    if done then done[entry.index] = nil end
    print(L.STEP_BACK)
    self:Refresh()
end

function Q:ResetRoute()
    local route = self:GetActiveRoute()
    if not route then return end
    self.char.done[route.key] = {}
    local kept = {}
    for _, entry in ipairs(self.char.history) do
        if entry.route ~= route.key then kept[#kept + 1] = entry end
    end
    self.char.history = kept
    self.routeAdvanced = nil
    print(L.ROUTE_RESET)
    self:Refresh()
end

-- ---------------------------------------------------------------------
-- Læring: ret quest-id'er og koordinater ud fra hvad der faktisk sker
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

-- Find trin i den aktive rute hvis titel matcher `title`.
function Q:FindStepsByTitle(title)
    local route = self:GetActiveRoute()
    if not route or not title then return {} end
    local hits = {}
    for _, step in ipairs(route.steps) do
        for _, q in ipairs(step.quests) do
            if q.title == title then hits[#hits + 1] = { step = step, q = q } end
        end
    end
    return hits
end

function Q:OnQuestAccepted(questID)
    if not questID or not self:GetActiveRoute() then return end
    -- Titlen kendes først når loggen er opdateret
    C_Timer.After(0.3, function()
        self:ScanQuestLog()
        local title
        for t, id in pairs(self.snapshot.byTitle) do
            if id == questID then title = t break end
        end
        if not title then return end
        for _, hit in ipairs(self:FindStepsByTitle(title)) do
            if hit.q.id ~= questID and self.db.learned.ids[title] ~= questID then
                self.db.learned.ids[title] = questID
                print(string.format(L.LEARNED_ID, questID, title, tostring(hit.q.id)))
            end
            if hit.step.type == "ACCEPT" and not self.db.learned.accept[title] then
                self.db.learned.accept[title] = PlayerCoords()
            end
        end
        self:Refresh()
    end)
end

function Q:OnQuestTurnedIn(questID)
    if not questID then return end
    self.char.turnedIn[questID] = true
    -- Match mod det aktuelle trin, så titel-baserede trin også lukkes
    local step = self:GetCurrentStep()
    if step then
        for _, q in ipairs(step.quests) do
            for _, id in ipairs(self:QuestCandidates(q)) do
                if id == questID and q.title then
                    self.char.turnedIn[q.title] = true
                    if step.type == "TURNIN" and not self.db.learned.turnin[q.title] then
                        self.db.learned.turnin[q.title] = PlayerCoords()
                    end
                end
            end
        end
    end
    self:Refresh()
end

-- ---------------------------------------------------------------------
-- Refresh (samler flere events til én opdatering)
-- ---------------------------------------------------------------------
local refreshPending = false
function Q:Refresh()
    if refreshPending then return end
    refreshPending = true
    C_Timer.After(0.15, function()
        refreshPending = false
        Q:DoRefresh()
    end)
end

function Q:DoRefresh()
    self:ScanQuestLog()
    local route = self:GetActiveRoute()
    self.current = self:CurrentStepIndex()

    -- Rute fuldført -> skift automatisk til den næste
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

    if ns.Tracker then ns.Tracker:Update() end
    if ns.Arrow then ns.Arrow:UpdateTarget() end
end
