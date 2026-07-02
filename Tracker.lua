local _, ns = ...
local L = ns.L

-- =========================================================================
-- Qeasy Tracker: viser det aktuelle trin (fremhævet) og de næste par trin,
-- med knapper til at springe over / gå tilbage.
-- =========================================================================

local Tracker = {}
ns.Tracker = Tracker

local UPCOMING = 3 -- antal kommende trin der vises nedtonet

local TYPE_STYLE = {
    ACCEPT = { tag = "!", r = 1.00, g = 0.82, b = 0.00 },
    TURNIN = { tag = "?", r = 1.00, g = 0.82, b = 0.00 },
    DO     = { tag = "•", r = 0.90, g = 0.90, b = 0.90 },
    TRAVEL = { tag = "»", r = 0.41, g = 0.80, b = 0.94 },
    NOTE   = { tag = "i", r = 0.60, g = 0.60, b = 1.00 },
}

local backdropTemplate = BackdropTemplateMixin and "BackdropTemplate" or nil
local frame = CreateFrame("Frame", "QeasyTrackerFrame", UIParent, backdropTemplate)
frame:SetSize(280, 150)
frame:SetPoint("RIGHT", UIParent, "RIGHT", -40, 60)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)
frame:Hide()

if frame.SetBackdrop then
    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    frame:SetBackdropColor(0, 0, 0, 0.75)
    frame:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.9)
end

frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, _, x, y = self:GetPoint()
    ns.Q.char.ui.trackerPos = { point = point, x = x, y = y }
end)

-- Header
local header = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
header:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -8)
header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -50, -8)
header:SetJustifyH("LEFT")
header:SetWordWrap(false)
header:SetTextColor(0.41, 0.80, 0.94)

local counter = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
counter:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -28, -9)
counter:SetJustifyH("RIGHT")

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetSize(22, 22)
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
closeBtn:SetScript("OnClick", function() Tracker:SetShown(false) end)

-- Aktuelt trin
local stepType = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
stepType:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -8)

local stepText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
stepText:SetPoint("TOPLEFT", stepType, "BOTTOMLEFT", 0, -2)
stepText:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
stepText:SetJustifyH("LEFT")
stepText:SetWordWrap(true)
stepText:SetSpacing(2)

local noteText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
noteText:SetPoint("TOPLEFT", stepText, "BOTTOMLEFT", 0, -4)
noteText:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
noteText:SetJustifyH("LEFT")
noteText:SetWordWrap(true)
noteText:SetSpacing(2)
noteText:SetTextColor(0.75, 0.75, 0.75)

-- Kommende trin (nedtonet)
local upcoming = {}
for i = 1, UPCOMING do
    local fs = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    if i == 1 then
        fs:SetPoint("TOPLEFT", noteText, "BOTTOMLEFT", 0, -8)
    else
        fs:SetPoint("TOPLEFT", upcoming[i - 1], "BOTTOMLEFT", 0, -3)
    end
    fs:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
    fs:SetJustifyH("LEFT")
    fs:SetWordWrap(false)
    upcoming[i] = fs
end

-- Knapper
local backBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
backBtn:SetSize(90, 20)
backBtn:SetText(L.BTN_BACK)
backBtn:SetScript("OnClick", function() ns.Q:Back() end)

local skipBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
skipBtn:SetSize(110, 20)
skipBtn:SetText(L.BTN_SKIP)
skipBtn:SetScript("OnClick", function() ns.Q:SkipCurrent() end)

backBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 8)
skipBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 8)

-- ---------------------------------------------------------------------
local function StepLine(step, withNote)
    local style = TYPE_STYLE[step.type]
    local title = step.quests[1] and step.quests[1].title
    local text
    if title then
        text = string.format("%s %s: %s", style.tag, L["TYPE_" .. step.type], title)
    else
        text = string.format("%s %s", style.tag, step.label or step.note or L["TYPE_" .. step.type])
    end
    if step.optional then text = text .. " (valgfri)" end
    return text, style
end

function Tracker:Update()
    local Q = ns.Q
    if not Q.char.ui.trackerShown then
        frame:Hide()
        return
    end
    frame:Show()

    local route = Q:GetActiveRoute()
    if not route then
        header:SetText("Qeasy")
        counter:SetText("")
        stepType:SetText("")
        stepText:SetText(L.TRACKER_EMPTY)
        noteText:SetText("")
        for i = 1, UPCOMING do upcoming[i]:SetText("") end
        frame:SetHeight(90)
        return
    end

    header:SetText(route.title)
    local total = #route.steps
    local current = Q.current

    if not current then
        counter:SetFormattedText(L.STEP_COUNTER, total, total)
        stepType:SetText("")
        stepText:SetText(string.format(L.ROUTE_COMPLETE, ""))
        noteText:SetText("")
        for i = 1, UPCOMING do upcoming[i]:SetText("") end
        frame:SetHeight(100)
        return
    end

    local step = route.steps[current]
    counter:SetFormattedText(L.STEP_COUNTER, current, total)

    local line, style = StepLine(step)
    stepType:SetText(L["TYPE_" .. step.type] .. (step.optional and " (valgfri)" or ""))
    stepType:SetTextColor(style.r, style.g, style.b)

    local title = step.quests[1] and step.quests[1].title
    stepText:SetText(title or step.label or "")
    noteText:SetText(step.note or "")

    -- Kommende trin
    local shown = 0
    local i = current + 1
    while shown < UPCOMING and i <= total do
        local s = route.steps[i]
        if not Q:IsStepDone(route, s) then
            shown = shown + 1
            local text = StepLine(s)
            upcoming[shown]:SetText(text)
        end
        i = i + 1
    end
    for j = shown + 1, UPCOMING do upcoming[j]:SetText("") end

    -- Dynamisk højde
    local height = 8 + 16 + 8 + 14 + 2 + stepText:GetStringHeight() + 4
    if step.note then height = height + noteText:GetStringHeight() end
    height = height + 8 + shown * 17 + 12 + 20 + 8
    frame:SetHeight(height)
end

function Tracker:SetShown(shown)
    ns.Q.char.ui.trackerShown = shown
    self:Update()
end

function Tracker:RestorePosition()
    local pos = ns.Q.char.ui.trackerPos
    if pos then
        frame:ClearAllPoints()
        frame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
    end
end
