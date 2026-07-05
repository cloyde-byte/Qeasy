local _, ns = ...
local L = ns.L

-- =========================================================================
-- Qeasy ObjectiveTracker: Questie-agtigt vindue der viser dine AKTIVE quests
-- grupperet efter zone, med objectives/fremgang og farve efter sværhedsgrad.
-- Klik en quest-titel for at folde dens objectives sammen.
-- =========================================================================

local Tracker = {}
ns.ObjTracker = Tracker

local backdrop = BackdropTemplateMixin and "BackdropTemplate" or nil
local frame = CreateFrame("Frame", "QeasyObjectiveTracker", UIParent, backdrop)
frame:SetSize(260, 100)
frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 20, -200)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)
frame:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local p, _, _, x, y = self:GetPoint()
    ns.Q.char.ui.objTrackerPos = { point = p, x = x, y = y }
end)
frame:Hide()

if frame.SetBackdrop then
    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    frame:SetBackdropColor(0, 0, 0, 0.6)
    frame:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
end

local header = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
header:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -8)
header:SetTextColor(1, 0.82, 0)

-- Rækker (genbrugspulje). Hver række er en knap, så quest-titler kan klikkes.
local rows = {}
local function getRow(i)
    if rows[i] then return rows[i] end
    local b = CreateFrame("Button", nil, frame)
    b:SetHeight(13)
    b.bg = b:CreateTexture(nil, "BACKGROUND")
    b.bg:SetAllPoints(b)
    b.bg:SetColorTexture(0.42, 0.80, 0.94, 0.14)  -- Qeasy-cyan highlight for aktiv quest
    b.bg:Hide()
    b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    b.text:SetPoint("LEFT", b, "LEFT", 0, 0)
    b.text:SetPoint("RIGHT", b, "RIGHT", 0, 0)
    b.text:SetJustifyH("LEFT")
    b.text:SetWordWrap(false)
    rows[i] = b
    return b
end

local function hideRowsFrom(n)
    for i = n, #rows do rows[i]:Hide() end
end

function Tracker:Collapsed()
    ns.Q.char.ui.trackerCollapsed = ns.Q.char.ui.trackerCollapsed or {}
    return ns.Q.char.ui.trackerCollapsed
end

-- Scroll-tilstand + max-højde, så trackeren ikke vokser ud af proportioner.
local LINE_H, HEAD_H, PAD = 14, 24, 6
Tracker.scroll = 0

local scrollHint = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
scrollHint:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 6)
scrollHint:SetTextColor(0.55, 0.7, 0.85)

frame:EnableMouseWheel(true)
frame:SetScript("OnMouseWheel", function(_, delta)
    Tracker.scroll = Tracker.scroll - delta
    Tracker:Update()
end)

-- Hvilken quest er spilleren "i gang med"? Løftes til toppen og fremhæves.
--  1) manuelt valgt (venstreklik)  2) klientens super-track
--  3) quest fra Qeasys aktuelle rute-step  4) første ufærdige quest
function Tracker:ActiveQuestID()
    local scan = ns.QuestLog:Scan()
    local live = {}
    for _, e in ipairs(scan) do if e.questID then live[e.questID] = e end end

    local f = ns.Q.char.ui.trackerFocus
    if f and live[f] and not live[f].isComplete then return f end

    if C_SuperTrack and C_SuperTrack.GetSuperTrackedQuestID then
        local q = C_SuperTrack.GetSuperTrackedQuestID()
        if q and q ~= 0 and live[q] and not live[q].isComplete then return q end
    end

    if ns.Q.GetCurrentStep then
        local ok, step = pcall(function() return ns.Q:GetCurrentStep() end)
        if ok and step and step.elements then
            for _, el in ipairs(step.elements) do
                local qid = el.q and el.q.id
                if qid and live[qid] and not live[qid].isComplete then return qid end
            end
        end
    end

    for _, e in ipairs(scan) do
        if e.questID and not e.isComplete then return e.questID end
    end
    return nil
end

-- Tilføj én quest (titel + objectives) til linjelisten.
local function questBlock(lines, e, active)
    local collapsed = Tracker:Collapsed()
    local isCol = collapsed[e.questID] and not active
    local r, g, b = ns.QuestLog:DiffColor(e.level)
    if active then r, g, b = 1, 0.9, 0.35 end   -- fremhævet guld
    local mark = active and "\226\150\182 " or (isCol and "+ " or "- ")  -- ▶ / + / -
    lines[#lines + 1] = {
        text = string.format("%s[%d] %s", mark, e.level, e.title),
        r = r, g = g, b = b, qid = e.questID, qtitle = e.title, qlevel = e.level,
        active = active,
    }
    if not isCol then
        if e.isComplete then
            lines[#lines + 1] = { text = "      " .. L.QUEST_COMPLETE, r = 0.2, g = 1, b = 0.2 }
        else
            for _, obj in ipairs(e.objectives) do
                local oc = obj.done and 0.2 or 0.85
                lines[#lines + 1] = { text = "      " .. obj.text,
                    r = oc, g = obj.done and 1 or 0.85, b = oc }
            end
        end
    end
end

-- Byg en flad liste af linjer (så vi nemt kan vise et scroll-vindue).
local function buildLines()
    local lines = {}
    local scan = ns.QuestLog:Scan()
    local activeQID = Tracker:ActiveQuestID()

    -- Aktiv quest øverst, fremhævet.
    if activeQID then
        for _, e in ipairs(scan) do
            if e.questID == activeQID then
                lines[#lines + 1] = { text = L.TRACKER_ACTIVE, r = 0.42, g = 0.80, b = 0.94 }
                questBlock(lines, e, true)
                break
            end
        end
    end

    -- Resten, grupperet efter zone (den aktive springes over).
    local pendingHeader = nil
    for _, e in ipairs(scan) do
        if e.isHeader then
            pendingHeader = e.name
        elseif e.questID and e.questID ~= activeQID then
            if pendingHeader then
                lines[#lines + 1] = { text = pendingHeader, r = 0.7, g = 0.7, b = 0.7 }
                pendingHeader = nil
            end
            questBlock(lines, e)
        end
    end
    return lines
end

function Tracker:Update()
    if not ns.Q.char.ui.objTrackerShown then frame:Hide() return end
    frame:Show()

    local done, total = ns.QuestLog:Counts()
    header:SetFormattedText("|cff69ccf0Qeasy|r Tracker: %d/%d", done, total)

    local lines = buildLines()
    if #lines == 0 then
        lines[1] = { text = L.TRACKER_NOQUESTS, r = 0.6, g = 0.6, b = 0.6 }
    end

    -- Max-højde: konfigurerbar, men aldrig mere end 82% af skærmen.
    local screenH = UIParent:GetHeight() or 768
    local maxH = math.min(ns.Q.char.ui.trackerMaxHeight or 460, screenH * 0.82)
    local maxLines = math.max(4, math.floor((maxH - HEAD_H - PAD) / LINE_H))

    local clipped = #lines > maxLines
    local visLines = clipped and (maxLines - 1) or #lines  -- reservér 1 linje til scroll-hint
    local maxScroll = math.max(0, #lines - visLines)
    if self.scroll > maxScroll then self.scroll = maxScroll end
    if self.scroll < 0 then self.scroll = 0 end

    local width = frame:GetWidth() - 20
    local y = -HEAD_H
    local shown = 0
    for i = self.scroll + 1, math.min(#lines, self.scroll + visLines) do
        shown = shown + 1
        local ln = lines[i]
        local row = getRow(shown)
        row.text:SetText(ln.text)
        row.text:SetTextColor(ln.r, ln.g, ln.b)
        if ln.active then row.bg:Show() else row.bg:Hide() end
        if ln.qid then
            local qid, qtitle, qlevel = ln.qid, ln.qtitle, ln.qlevel
            row:EnableMouse(true)
            row:RegisterForClicks("LeftButtonUp")
            row:SetScript("OnClick", function()
                if IsShiftKeyDown() and ns.Links then
                    ns.Links:Insert(qid, qtitle, qlevel)          -- link i chat
                elseif IsControlKeyDown() then
                    local c = Tracker:Collapsed()
                    c[qid] = (not c[qid]) or nil                  -- fold sammen
                    Tracker:Update()
                else
                    local ui = ns.Q.char.ui                        -- fokusér (løft til top)
                    ui.trackerFocus = (ui.trackerFocus ~= qid) and qid or nil
                    Tracker:Update()
                    if ns.Map then ns.Map:UpdateWorldMap() end      -- opdatér spawn-sky
                end
            end)
            row:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:AddLine(qtitle or "", 1, 0.85, 0.30)
                local prog = ns.Comms and ns.Comms:ProgressFor(qid)
                if prog and #prog > 0 then
                    GameTooltip:AddLine("|cff69ccf0Gruppe:|r")
                    for _, p in ipairs(prog) do
                        GameTooltip:AddDoubleLine("  " .. p.name, p.text, 0.9, 0.9, 0.9, 0.6, 0.85, 1)
                    end
                end
                GameTooltip:AddLine(L.TRACKER_ROWHINT, 0.5, 0.5, 0.5)
                GameTooltip:Show()
            end)
            row:SetScript("OnLeave", function() GameTooltip:Hide() end)
        else
            row.bg:Hide()
            row:EnableMouse(false)
            row:SetScript("OnClick", nil)
            row:SetScript("OnEnter", nil)
            row:SetScript("OnLeave", nil)
        end
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, y)
        row:SetWidth(width)
        row:Show()
        y = y - LINE_H
    end
    hideRowsFrom(shown + 1)

    if clipped then
        scrollHint:SetFormattedText("%s %d-%d af %d  (scroll)", "\226\150\178\226\150\188",
            self.scroll + 1, self.scroll + shown, #lines)
        scrollHint:Show()
        y = y - LINE_H
    else
        scrollHint:Hide()
    end

    frame:SetHeight(HEAD_H + shown * LINE_H + (clipped and LINE_H or 0) + PAD)
end

function Tracker:SetShown(shown)
    ns.Q.char.ui.objTrackerShown = shown
    self:Update()
end

function Tracker:RestorePosition()
    local pos = ns.Q.char.ui.objTrackerPos
    if pos then
        frame:ClearAllPoints()
        frame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
    end
    frame:SetScale(ns.Q.char.ui.objTrackerScale or 1)
end
