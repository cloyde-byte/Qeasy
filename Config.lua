local _, ns = ...
local L = ns.L

-- =========================================================================
-- Qeasy Config: et rigtigt indstillingsvindue (i stedet for slash-tekst).
-- Åbnes med /qeasy. Registreres også i Blizzards AddOn-indstillinger, hvis
-- API'et findes.
-- =========================================================================

local Config = {}
ns.Config = Config

local backdrop = BackdropTemplateMixin and "BackdropTemplate" or nil
local frame = CreateFrame("Frame", "QeasyConfigFrame", UIParent, backdrop)
frame:SetSize(340, 470)
frame:SetPoint("CENTER")
frame:SetFrameStrata("HIGH")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()

if frame.SetBackdrop then
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 24,
        insets = { left = 6, right = 6, top = 6, bottom = 6 },
    })
end

-- Logo (Waypoint Q-medaljon) + gyldent ordmærke i headeren
local logo = frame:CreateTexture(nil, "ARTWORK")
logo:SetSize(52, 52)
logo:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -12)
logo:SetTexture("Interface\\AddOns\\Qeasy\\Media\\logo")

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("LEFT", logo, "RIGHT", 10, 9)
title:SetText("Qeasy")
title:SetTextColor(0.93, 0.72, 0.22)  -- WoW-guld
if title.SetFont then
    local f = title:GetFont()
    if f then title:SetFont(f, 26, "") end
end

local subtitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 1, -3)
subtitle:SetText("Outland leveling, gjort let")
subtitle:SetTextColor(0.42, 0.80, 0.94)  -- Qeasy-cyan

local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)
close:SetScript("OnClick", function() frame:Hide() end)

-- ---------------------------------------------------------------------
-- Hjælpere til widgets
-- ---------------------------------------------------------------------
local y = -74
local function section(text)
    local fs = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, y)
    fs:SetText(text)
    fs:SetTextColor(1, 0.82, 0)
    y = y - 22
    return fs
end

local function checkbox(labeltext, getter, setter)
    local cb = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", frame, "TOPLEFT", 22, y)
    cb:SetSize(24, 24)
    local t = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    t:SetPoint("LEFT", cb, "RIGHT", 4, 0)
    t:SetText(labeltext)
    cb.qGet = getter
    cb:SetScript("OnClick", function(self)
        setter(self:GetChecked() and true or false)
    end)
    y = y - 26
    return cb
end

local function slider(labeltext, minv, maxv, getter, setter)
    local s = CreateFrame("Slider", nil, frame, "OptionsSliderTemplate")
    s:SetPoint("TOPLEFT", frame, "TOPLEFT", 26, y - 14)
    s:SetWidth(280)
    s:SetMinMaxValues(minv, maxv)
    s:SetValueStep(0.05)
    if s.SetObeyStepOnDrag then s:SetObeyStepOnDrag(true) end
    local t = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    t:SetPoint("BOTTOMLEFT", s, "TOPLEFT", 0, 2)
    local val = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    val:SetPoint("BOTTOMRIGHT", s, "TOPRIGHT", 0, 2)
    s.qLabel, s.qVal, s.qText = t, val, labeltext
    s:SetScript("OnValueChanged", function(self, v)
        v = math.floor(v * 20 + 0.5) / 20
        self.qVal:SetText(string.format("%d%%", math.floor(v * 100 + 0.5)))
        setter(v)
    end)
    s.qGet = getter
    y = y - 44
    return s
end

-- ---------------------------------------------------------------------
-- Widgets
-- ---------------------------------------------------------------------
section(L.CFG_DISPLAY)
local cbGuide = checkbox(L.CFG_GUIDE,
    function() return ns.Q.char.ui.guideShown end,
    function(v) ns.Guide:SetShown(v) end)
local cbArrow = checkbox(L.CFG_ARROW,
    function() return ns.Q.char.ui.arrowShown end,
    function(v) ns.Arrow:SetShown(v) end)
local cbAuto = checkbox(L.CFG_AUTOROUTE,
    function() return ns.Q.char.ui.autoRoute ~= false end,
    function(v) ns.Q.char.ui.autoRoute = v end)
local cbObjTracker = checkbox(L.CFG_OBJTRACKER,
    function() return ns.Q.char.ui.objTrackerShown ~= false end,
    function(v) ns.ObjTracker:SetShown(v) end)
local cbTooltips = checkbox(L.CFG_TOOLTIPS,
    function() return ns.Q.char.ui.tooltipsEnabled ~= false end,
    function(v) ns.Q.char.ui.tooltipsEnabled = v end)
local cbMapIcons = checkbox(L.CFG_MAPICONS,
    function() return ns.Q.char.ui.mapIcons ~= false end,
    function(v) ns.Q.char.ui.mapIcons = v; if ns.Map then ns.Map:UpdateWorldMap() end end)
local cbMiniIcons = checkbox(L.CFG_MINIMAPICONS,
    function() return ns.Q.char.ui.minimapIcons ~= false end,
    function(v) ns.Q.char.ui.minimapIcons = v end)
local cbMMButton = checkbox(L.CFG_MMBUTTON,
    function() return ns.Q.char.ui.minimapButton ~= false end,
    function(v) ns.Q.char.ui.minimapButton = v; ns.Config:UpdateMinimapButton() end)

local sGuide = slider(L.CFG_GUIDESCALE, 0.7, 1.6,
    function() return ns.Q.char.ui.guideScale or 1 end,
    function(v) ns.Q.char.ui.guideScale = v; ns.Guide:ApplyScale() end)
local sArrow = slider(L.CFG_ARROWSCALE, 0.7, 1.8,
    function() return ns.Q.char.ui.arrowScale or 1 end,
    function(v) ns.Q.char.ui.arrowScale = v; ns.Arrow:ApplyScale() end)

section(L.CFG_ROUTES)
local routeButtons = {}
local function ensureRouteButtons()
    if #routeButtons > 0 then return end
    local ry = y
    for _, key in ipairs(ns.Q.routeOrder) do
        local route = ns.Q.routes[key]
        local b = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        b:SetSize(300, 20)
        b:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, ry)
        b:SetText(string.format("%s  (%s)", route.title, route.levels or ""))
        b.qKey = key
        b:SetScript("OnClick", function()
            ns.Q:SetActiveRoute(key)
            Config:Refresh()
        end)
        routeButtons[#routeButtons + 1] = b
        ry = ry - 23
    end
    -- Nulstil-knap
    local reset = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    reset:SetSize(300, 22)
    reset:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, ry - 4)
    reset:SetText(L.CFG_RESET)
    reset:SetScript("OnClick", function() ns.Q:ResetRoute(); Config:Refresh() end)
    ry = ry - 30
    local hint = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hint:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, ry)
    hint:SetPoint("RIGHT", frame, "RIGHT", -16, 0)
    hint:SetJustifyH("LEFT")
    hint:SetWordWrap(true)
    hint:SetText(L.CFG_OPEN_HINT)
    frame:SetHeight(math.abs(ry) + 60)
end

-- ---------------------------------------------------------------------
function Config:Refresh()
    cbGuide:SetChecked(cbGuide.qGet())
    cbArrow:SetChecked(cbArrow.qGet())
    cbAuto:SetChecked(cbAuto.qGet())
    cbObjTracker:SetChecked(cbObjTracker.qGet())
    cbTooltips:SetChecked(cbTooltips.qGet())
    cbMapIcons:SetChecked(cbMapIcons.qGet())
    cbMiniIcons:SetChecked(cbMiniIcons.qGet())
    cbMMButton:SetChecked(cbMMButton.qGet())
    for _, s in ipairs({ sGuide, sArrow }) do
        local v = s.qGet()
        s:SetValue(v)
        s.qLabel:SetText(s.qText)
        s.qVal:SetText(string.format("%d%%", math.floor(v * 100 + 0.5)))
    end
    local active = ns.Q.char.activeRoute
    for _, b in ipairs(routeButtons) do
        if b.qKey == active then
            b:SetNormalFontObject("GameFontHighlight")
            b:LockHighlight()
        else
            b:SetNormalFontObject("GameFontNormal")
            b:UnlockHighlight()
        end
    end
end

function Config:Open()
    ensureRouteButtons()
    frame:Show()
    self:Refresh()
end

function Config:Toggle()
    if frame:IsShown() then frame:Hide() else self:Open() end
end

-- Registrér i Blizzards AddOn-indstillinger (best-effort, versionssikkert).
function Config:RegisterBlizzard()
    local panel = CreateFrame("Frame", "QeasyBlizzOptions", UIParent)
    panel.name = "Qeasy"
    local t = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    t:SetPoint("TOPLEFT", 16, -16)
    t:SetText("Qeasy")
    local b = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    b:SetSize(220, 24)
    b:SetPoint("TOPLEFT", 16, -48)
    b:SetText(L.CFG_BUTTON)
    b:SetScript("OnClick", function() Config:Open() end)
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        local cat = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Settings.RegisterAddOnCategory(cat)
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    end
end

-- ---------------------------------------------------------------------
-- Minimap-knap (Waypoint Q) - venstreklik åbner indstillinger, træk flytter
-- ---------------------------------------------------------------------
local atan2 = math.atan2 or function(a, b) return math.atan(a, b) end

local function positionMinimapButton(btn)
    local ang = math.rad(ns.Q.char.ui.minimapButtonAngle or 210)
    local r = 80
    btn:SetPoint("CENTER", Minimap, "CENTER", math.cos(ang) * r, math.sin(ang) * r)
end

function Config:CreateMinimapButton()
    if self.mmbtn or not Minimap then return end
    local b = CreateFrame("Button", "QeasyMinimapButton", Minimap)
    b:SetFrameStrata("MEDIUM")
    b:SetFrameLevel(8)
    b:SetSize(31, 31)
    b:SetMovable(true)
    b:RegisterForClicks("LeftButtonUp")
    b:RegisterForDrag("LeftButton")

    local icon = b:CreateTexture(nil, "BACKGROUND")
    icon:SetSize(21, 21)
    icon:SetPoint("CENTER", 0, 0)
    icon:SetTexture("Interface\\AddOns\\Qeasy\\Media\\logo")

    local border = b:CreateTexture(nil, "OVERLAY")
    border:SetSize(53, 53)
    border:SetPoint("TOPLEFT", 0, 0)
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    b:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local mx, my = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            local cx, cy = Minimap:GetCenter()
            if not (mx and cx and scale and scale > 0) then return end
            ns.Q.char.ui.minimapButtonAngle = math.deg(atan2(my / scale - cy, mx / scale - cx))
            positionMinimapButton(self)
        end)
    end)
    b:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
    b:SetScript("OnClick", function() Config:Toggle() end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cff69ccf0Qeasy|r")
        GameTooltip:AddLine("Venstreklik: åbn indstillinger", 1, 1, 1)
        GameTooltip:AddLine("Træk: flyt knappen", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)

    positionMinimapButton(b)
    self.mmbtn = b
    self:UpdateMinimapButton()
end

function Config:UpdateMinimapButton()
    if not self.mmbtn then return end
    if ns.Q.char.ui.minimapButton == false then
        self.mmbtn:Hide()
    else
        self.mmbtn:Show()
    end
end
