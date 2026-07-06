local _, ns = ...

-- =========================================================================
-- Qeasy Session: RestedXP-agtig leveling-meta - XP/time, tid til næste level
-- og (ca.) tid til level 70, plus levels og spilletid denne session.
-- =========================================================================

local Session = {}
ns.Session = Session

local backdrop = BackdropTemplateMixin and "BackdropTemplate" or nil
local frame = CreateFrame("Frame", "QeasySessionFrame", UIParent, backdrop)
frame:SetSize(190, 84)
frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 20, -480)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)
frame:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local p, _, _, x, y = self:GetPoint()
    ns.Q.char.ui.sessionPos = { point = p, x = x, y = y }
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

local header = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
header:SetPoint("TOPLEFT", 10, -8)
header:SetTextColor(1, 0.82, 0)
header:SetText("|cff69ccf0Qeasy|r Session")

local body = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
body:SetPoint("TOPLEFT", 10, -24)
body:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
body:SetJustifyH("LEFT")
body:SetJustifyV("TOP")

local startT, xpEarned, lvlGained = 0, 0, 0
local lastXP, lastMax, lastLevel = 0, 0, 0

local function px() return UnitXP and UnitXP("player") or 0 end
local function pmax() return UnitXPMax and UnitXPMax("player") or 0 end
local function plvl() return UnitLevel and UnitLevel("player") or 0 end

function Session:Init()
    startT = GetTime and GetTime() or 0
    xpEarned, lvlGained = 0, 0
    lastXP, lastMax, lastLevel = px(), pmax(), plvl()
    self:Update()
end

-- Kaldes ved XP-ændring: læg optjent XP til (håndterer level-ups).
function Session:OnXP()
    local cur, max, lvl = px(), pmax(), plvl()
    if lvl > lastLevel then
        xpEarned = xpEarned + math.max(0, lastMax - lastXP) + cur
        lvlGained = lvlGained + (lvl - lastLevel)
    elseif cur >= lastXP then
        xpEarned = xpEarned + (cur - lastXP)
    end
    lastXP, lastMax, lastLevel = cur, max, lvl
    self:Update()
end

local function fmtTime(sec)
    if not sec or sec <= 0 or sec ~= sec or sec == math.huge then return "-" end
    sec = math.floor(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    if h > 0 then return string.format("%dt %02dm", h, m) end
    if m > 0 then return string.format("%dm %02ds", m, s) end
    return string.format("%ds", s)
end

local function bignum(n)
    n = math.floor(n)
    if BreakUpLargeNumbers then return BreakUpLargeNumbers(n) end
    return tostring(n)
end

function Session:Update()
    if ns.Q.char.ui.sessionStats == false then frame:Hide() return end
    local lvl = plvl()
    local max = pmax()
    if not (max and max > 0) then frame:Hide() return end   -- max level: skjul

    frame:Show()
    local now = GetTime and GetTime() or 0
    local elapsed = math.max(1, now - startT)
    local xps = xpEarned / elapsed                 -- XP/sekund
    local toNext = math.max(0, max - px())
    local tNext = xps > 0 and (toNext / xps) or nil
    local remLvls = math.max(0, 70 - lvl - 1)
    local t70 = xps > 0 and ((toNext + remLvls * max) / xps) or nil

    local lines = {
        string.format("XP/time: %s", bignum(xpEarned / (elapsed / 3600))),
        string.format("Til level %d: %s", lvl + 1, fmtTime(tNext)),
    }
    if lvl < 70 then
        lines[#lines + 1] = string.format("Til 70 (ca.): %s", fmtTime(t70))
    end
    lines[#lines + 1] = string.format("Denne: +%d lvl \194\183 %s", lvlGained, fmtTime(elapsed))
    body:SetText(table.concat(lines, "\n"))
    frame:SetHeight(24 + #lines * 13 + 8)
end

function Session:SetShown(v)
    ns.Q.char.ui.sessionStats = v
    self:Update()
end

function Session:RestorePosition()
    local pos = ns.Q.char.ui.sessionPos
    if pos then
        frame:ClearAllPoints()
        frame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
    end
    frame:SetScale(ns.Q.char.ui.sessionScale or 1)
end

-- 1s-tik: opdater nedtælling/tid (kører kun mens vinduet er synligt).
local acc = 0
frame:SetScript("OnUpdate", function(_, dt)
    acc = acc + dt
    if acc < 1 then return end
    acc = 0
    Session:Update()
end)
