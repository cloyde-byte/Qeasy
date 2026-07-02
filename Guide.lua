local _, ns = ...
local L = ns.L

-- =========================================================================
-- Qeasy Guide: RestedXP-agtigt vindue der viser det aktuelle step som en
-- liste af elementer med ikon + grønt flueben, plus de næste par steps.
-- =========================================================================

local Guide = {}
ns.Guide = Guide
ns.Tracker = Guide -- bagudkompatibelt alias

local MAX_ROWS = 8        -- elementer i det aktuelle step (nu små steps)
local UPCOMING = 4        -- kommende steps (som linjer)

-- Indbyggede spil-teksturer (ingen medier at sende med).
local ICON = {
    accept  = "Interface\\GossipFrame\\AvailableQuestIcon",
    turnin  = "Interface\\GossipFrame\\ActiveQuestIcon",
    ["do"]  = "Interface\\Icons\\Ability_DualWield",
    complete= "Interface\\Icons\\Ability_DualWield",
    travel  = "Interface\\Icons\\Ability_Rogue_Sprint",
    fly     = "Interface\\Icons\\Ability_Mount_Gryphon_01",
    hearth  = "Interface\\Icons\\INV_Misc_Rune_01",
    train   = "Interface\\Icons\\INV_Misc_Book_09",
    buy     = "Interface\\Icons\\INV_Misc_Coin_01",
    vendor  = "Interface\\Icons\\INV_Misc_Bag_10",
    repair  = "Interface\\Icons\\Trade_BlackSmithing",
    deliver = "Interface\\Icons\\INV_Letter_15",
    grind   = "Interface\\Icons\\Ability_Warrior_Riposte",
    ding    = "Interface\\Icons\\Spell_Holy_Heal",
    note    = "Interface\\Icons\\INV_Misc_Note_01",
    rep     = "Interface\\Icons\\INV_BannerPVP_02",
}
local CHECK = "Interface\\Buttons\\UI-CheckBox-Check"

local backdrop = BackdropTemplateMixin and "BackdropTemplate" or nil
local frame = CreateFrame("Frame", "QeasyGuideFrame", UIParent, backdrop)
frame:SetSize(300, 200)
frame:SetPoint("RIGHT", UIParent, "RIGHT", -30, 60)
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
    frame:SetBackdropColor(0, 0, 0, 0.82)
    frame:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.9)
end

frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, _, x, y = self:GetPoint()
    ns.Q.char.ui.guidePos = { point = point, x = x, y = y }
end)

-- Header
local header = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
header:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -8)
header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -52, -8)
header:SetJustifyH("LEFT")
header:SetWordWrap(false)
header:SetTextColor(0.41, 0.80, 0.94)

local counter = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
counter:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -28, -9)

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetSize(22, 22)
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
closeBtn:SetScript("OnClick", function() Guide:SetShown(false) end)

-- Step-overskrift
local stepLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
stepLabel:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -6)
stepLabel:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
stepLabel:SetJustifyH("LEFT")
stepLabel:SetWordWrap(false)
stepLabel:SetTextColor(1, 0.82, 0)

-- Element-rækker
local rows = {}
for i = 1, MAX_ROWS do
    local row = CreateFrame("Frame", nil, frame)
    row:SetHeight(16)
    if i == 1 then
        row:SetPoint("TOPLEFT", stepLabel, "BOTTOMLEFT", 0, -4)
    else
        row:SetPoint("TOPLEFT", rows[i - 1], "BOTTOMLEFT", 0, -2)
    end
    row:SetPoint("RIGHT", frame, "RIGHT", -10, 0)

    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(14, 14)
    row.icon:SetPoint("TOPLEFT", row, "TOPLEFT", 2, 0)

    row.check = row:CreateTexture(nil, "OVERLAY")
    row.check:SetSize(16, 16)
    row.check:SetPoint("CENTER", row.icon, "CENTER", 0, 0)
    row.check:SetTexture(CHECK)
    row.check:Hide()

    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.text:SetPoint("LEFT", row.icon, "RIGHT", 5, 0)
    row.text:SetPoint("RIGHT", row, "RIGHT", -2, 0)
    row.text:SetJustifyH("LEFT")
    row.text:SetWordWrap(false)

    rows[i] = row
end

-- Kommende steps
local upcoming = {}
for i = 1, UPCOMING do
    local fs = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    if i == 1 then
        fs:SetPoint("TOPLEFT", rows[MAX_ROWS], "BOTTOMLEFT", 0, -6)
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
backBtn:SetSize(95, 20)
backBtn:SetText(L.BTN_BACK)
backBtn:SetScript("OnClick", function() ns.Q:Back() end)
backBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 8)

local skipBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
skipBtn:SetSize(120, 20)
skipBtn:SetText(L.BTN_SKIP)
skipBtn:SetScript("OnClick", function() ns.Q:SkipStep() end)
skipBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 8)

-- ---------------------------------------------------------------------
local function ElementText(el)
    local q = el.q
    if q and q.title then
        local verb = (el.kind == "accept" and L.TYPE_ACCEPT)
            or (el.kind == "turnin" and L.TYPE_TURNIN)
            or L.TYPE_DO
        return verb .. ": " .. q.title
    end
    if el.kind == "ding" then
        return string.format("Ding %d!", el.level or 0)
    end
    if el.kind == "grind" then
        return el.text or string.format("Grind til level %d", el.level or 0)
    end
    return el.text or el.label or ""
end

function Guide:Update()
    local Q = ns.Q
    if not Q.char.ui.guideShown then frame:Hide() return end
    frame:Show()

    local route = Q:GetActiveRoute()
    for i = 1, MAX_ROWS do rows[i]:Hide() end
    for i = 1, UPCOMING do upcoming[i]:SetText("") end

    if not route then
        header:SetText("Qeasy")
        counter:SetText("")
        stepLabel:SetText(L.TRACKER_EMPTY)
        frame:SetHeight(70)
        return
    end

    header:SetText(route.title)
    local total = #route.steps
    local current = Q.current

    if not current then
        counter:SetFormattedText(L.STEP_COUNTER, total, total)
        stepLabel:SetText(string.format(L.ROUTE_COMPLETE, ""))
        frame:SetHeight(80)
        return
    end

    counter:SetFormattedText(L.STEP_COUNTER, current, total)
    local step = route.steps[current]
    stepLabel:SetText(step.label or "")

    -- Element-rækker
    local shown = 0
    for _, el in ipairs(step.elements) do
        if shown >= MAX_ROWS then break end
        shown = shown + 1
        local row = rows[shown]
        local done = Q:IsElementDone(route, step, el)
        row.icon:SetTexture(ICON[el.kind] or ICON.note)
        row.icon:SetDesaturated(done)
        row.text:SetText(ElementText(el) .. (el.optional and "  |cff808080(valgfri)|r" or ""))
        if done then
            row.check:Show()
            row.text:SetTextColor(0.5, 0.5, 0.5)
        else
            row.check:Hide()
            if el.kind == "accept" or el.kind == "turnin" then
                row.text:SetTextColor(1, 0.82, 0)
            else
                row.text:SetTextColor(0.95, 0.95, 0.95)
            end
        end
        row:Show()
    end

    -- Note fra første ufærdige element (kort hjælp)
    -- (vises som ekstra række hvis plads; ellers udeladt)

    -- Kommende steps (vis første handling i hvert)
    local up = 0
    local i = current + 1
    while up < UPCOMING and i <= total do
        local s = route.steps[i]
        if not Q:IsStepDone(route, s) then
            up = up + 1
            local first = s.elements[1]
            upcoming[up]:SetText("» " .. (first and ElementText(first) or (s.label or ("Step " .. i))))
        end
        i = i + 1
    end

    -- Dynamisk højde
    local h = 8 + 14 + 6 + 14 + 4 + shown * 18 + 6 + up * 15 + 10 + 20 + 8
    frame:SetHeight(h)
end

function Guide:SetShown(shown)
    ns.Q.char.ui.guideShown = shown
    self:Update()
end

function Guide:RestorePosition()
    local pos = ns.Q.char.ui.guidePos
    if pos then
        frame:ClearAllPoints()
        frame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
    end
    self:ApplyScale()
end

function Guide:ApplyScale()
    frame:SetScale(ns.Q.char.ui.guideScale or 1)
end
