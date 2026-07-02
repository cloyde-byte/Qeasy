local ADDON, ns = ...
local L = ns.L
local Q = ns.Q

-- =========================================================================
-- Qeasy Core: events, opstart og slash-kommandoer.
-- =========================================================================

local function GetVersion()
    if C_AddOns and C_AddOns.GetAddOnMetadata then
        return C_AddOns.GetAddOnMetadata(ADDON, "Version") or "?"
    end
    if GetAddOnMetadata then
        return GetAddOnMetadata(ADDON, "Version") or "?"
    end
    return "?"
end

local loadedPrinted = false
local factionWarned = false

local function IsHorde()
    return UnitFactionGroup and UnitFactionGroup("player") == "Horde"
end

Q:RegisterEvent("ADDON_LOADED")
Q:RegisterEvent("PLAYER_ENTERING_WORLD")
Q:RegisterEvent("QUEST_ACCEPTED")
Q:RegisterEvent("QUEST_TURNED_IN")
Q:RegisterEvent("QUEST_LOG_UPDATE")
Q:RegisterEvent("ZONE_CHANGED_NEW_AREA")

Q:SetScript("OnEvent", function(self, event, arg1, arg2)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON then
            self:InitDB()
            self:UnregisterEvent("ADDON_LOADED")
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        if not loadedPrinted then
            loadedPrinted = true
            print(string.format(L.ADDON_LOADED, GetVersion()))
        end
        ns.Tracker:RestorePosition()
        ns.Arrow:RestorePosition()
        if IsHorde() then
            self:AutoPickRoute()
        elseif not factionWarned then
            factionWarned = true
            print(L.NOT_HORDE)
        end
        self:Refresh()

    elseif event == "QUEST_ACCEPTED" then
        -- Klassisk klient: (questLogIndex, questID). Nyere: (questID).
        local questID = arg2 or arg1
        self:OnQuestAccepted(questID)

    elseif event == "QUEST_TURNED_IN" then
        self:OnQuestTurnedIn(arg1)

    elseif event == "QUEST_LOG_UPDATE" then
        self:Refresh()

    elseif event == "ZONE_CHANGED_NEW_AREA" then
        if IsHorde() then self:AutoPickRoute() end
        self:Refresh()
    end
end)

-- ---------------------------------------------------------------------
-- Slash-kommandoer
-- ---------------------------------------------------------------------
local function PrintHelp()
    for _, line in ipairs(L.HELP) do print(line) end
end

local function Debug()
    local route = Q:GetActiveRoute()
    if not route then print("Qeasy: ingen aktiv rute.") return end
    print(string.format("Qeasy: rute '%s', step %s af %d", route.key, tostring(Q.current), #route.steps))
    local step = Q:GetCurrentStep()
    if not step then return end
    print(string.format("  step '%s' med %d elementer:", tostring(step.label), #step.elements))
    for _, el in ipairs(step.elements) do
        local done = Q:IsElementDone(route, step, el)
        local extra = ""
        if el.q then
            local on, complete = Q:IsQuestOn(el.q)
            extra = string.format(" id=%s log=%s færdig=%s afl=%s", tostring(el.q.id),
                tostring(on), tostring(complete), tostring(Q:IsQuestTurnedIn(el.q)))
        end
        local coords = Q:ElementTarget(el)
        local pos = coords and string.format(" @%d %.1f,%.1f", coords.map, coords.x, coords.y) or ""
        print(string.format("  [%s] %s '%s'%s%s", done and "x" or " ", el.kind,
            tostring((el.q and el.q.title) or el.text or el.label or ""), extra, pos))
    end
end

SLASH_QEASY1 = "/qeasy"
SLASH_QEASY2 = "/qe"
SlashCmdList["QEASY"] = function(msg)
    msg = (msg or ""):gsub("^%s+", ""):gsub("%s+$", "")
    local cmd, rest = msg:match("^(%S*)%s*(.-)$")
    cmd = cmd:lower()

    if cmd == "" or cmd == "help" then
        PrintHelp()
    elseif cmd == "show" then
        ns.Tracker:SetShown(true)
        ns.Arrow:SetShown(true)
    elseif cmd == "hide" then
        ns.Tracker:SetShown(false)
        ns.Arrow:SetShown(false)
    elseif cmd == "arrow" then
        ns.Arrow:SetShown(not Q.char.ui.arrowShown)
    elseif cmd == "skip" then
        Q:SkipStep()
    elseif cmd == "back" then
        Q:Back()
    elseif cmd == "reset" then
        Q:ResetRoute()
    elseif cmd == "list" then
        print(L.ROUTE_LIST)
        for _, key in ipairs(Q.routeOrder) do
            local route = Q.routes[key]
            local marker = (Q.char.activeRoute == key) and " |cff00ff00<- aktiv|r" or ""
            print(string.format("  |cffffff00%s|r - %s (%s)%s", key, route.title, route.levels or "", marker))
        end
    elseif cmd == "route" then
        Q:SetActiveRoute(rest)
    elseif cmd == "debug" then
        Debug()
    else
        PrintHelp()
    end
end
