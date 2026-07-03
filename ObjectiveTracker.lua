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

function Tracker:Update()
    if not ns.Q.char.ui.objTrackerShown then frame:Hide() return end
    frame:Show()

    local done, total = ns.QuestLog:Counts()
    header:SetFormattedText("|cff69ccf0Qeasy|r Tracker: %d/%d", done, total)

    local collapsed = self:Collapsed()
    local data = ns.QuestLog:Scan()
    local width = frame:GetWidth() - 20
    local y = -26
    local n = 0
    local pendingHeader = nil  -- vis kun zone-overskrifter der har quests

    local function place(row)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, y)
        row:SetWidth(width)
        row:Show()
        y = y - 14
    end

    for _, e in ipairs(data) do
        if e.isHeader then
            pendingHeader = e.name
        elseif e.questID then
            if pendingHeader then
                n = n + 1
                local row = getRow(n)
                row.text:SetText(pendingHeader)
                row.text:SetTextColor(0.7, 0.7, 0.7)
                row:SetScript("OnClick", nil)
                row:EnableMouse(false)
                place(row)
                pendingHeader = nil
            end
            -- Quest-titel (klikbar: fold objectives)
            n = n + 1
            local row = getRow(n)
            local isCol = collapsed[e.questID]
            local prefix = isCol and "+ " or "- "
            row.text:SetFormattedText("%s[%d] %s", prefix, e.level, e.title)
            local r, g, b = ns.QuestLog:DiffColor(e.level)
            row.text:SetTextColor(r, g, b)
            row:EnableMouse(true)
            local qid = e.questID
            row:SetScript("OnClick", function()
                local c = Tracker:Collapsed()
                c[qid] = (not c[qid]) or nil
                Tracker:Update()
            end)
            place(row)

            if not isCol then
                if e.isComplete then
                    n = n + 1
                    local o = getRow(n)
                    o.text:SetText("      " .. L.QUEST_COMPLETE)
                    o.text:SetTextColor(0.2, 1.0, 0.2)
                    o:SetScript("OnClick", nil); o:EnableMouse(false)
                    place(o)
                else
                    for _, obj in ipairs(e.objectives) do
                        n = n + 1
                        local o = getRow(n)
                        o.text:SetText("      " .. obj.text)
                        if obj.done then
                            o.text:SetTextColor(0.2, 1.0, 0.2)
                        else
                            o.text:SetTextColor(0.85, 0.85, 0.85)
                        end
                        o:SetScript("OnClick", nil); o:EnableMouse(false)
                        place(o)
                    end
                end
            end
        end
    end

    hideRowsFrom(n + 1)

    if n == 0 then
        n = 1
        local row = getRow(1)
        row.text:SetText(L.TRACKER_NOQUESTS)
        row.text:SetTextColor(0.6, 0.6, 0.6)
        row:SetScript("OnClick", nil); row:EnableMouse(false)
        place(row)
    end

    frame:SetHeight(26 + (-y) + 6)
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
