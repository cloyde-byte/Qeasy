local _, ns = ...
local L = ns.L

-- =========================================================================
-- Qeasy Arrow: GPS-pil der peger mod det aktuelle trins koordinater.
-- Vinklen beregnes ud fra world-koordinater (C_Map.GetWorldPosFromMapPos),
-- så pilen også virker på tværs af zoner på samme kontinent.
-- =========================================================================

local Arrow = {}
ns.Arrow = Arrow

local sqrt, atan2, abs, pi = math.sqrt, math.atan2, math.abs, math.pi

local frame = CreateFrame("Frame", "QeasyArrowFrame", UIParent)
frame:SetSize(140, 100)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 220)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)
frame:Hide()

frame:SetScript("OnDragStart", function(self)
    if IsShiftKeyDown() then self:StartMoving() end
end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, _, x, y = self:GetPoint()
    ns.Q.char.ui.arrowPos = { point = point, x = x, y = y }
end)

local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
label:SetPoint("TOP", frame, "TOP", 0, 0)
label:SetWidth(220)
label:SetWordWrap(false)

local arrow = frame:CreateTexture(nil, "ARTWORK")
arrow:SetSize(56, 56)
arrow:SetPoint("TOP", label, "BOTTOM", 0, -2)
arrow:SetTexture("Interface\\AddOns\\Qeasy\\Media\\arrow")

local distText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
distText:SetPoint("TOP", arrow, "BOTTOM", 0, -2)

-- ---------------------------------------------------------------------
-- Koordinat-hjælpere
-- ---------------------------------------------------------------------
local function WorldPos(mapID, x, y)
    if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then return nil end
    local continent, world = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(x / 100, y / 100))
    if not world then return nil end
    return continent, world.x, world.y
end

local function PlayerWorldPos()
    local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    if not mapID then return nil end
    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then return nil end
    local x, y = pos:GetXY()
    if not x or (x == 0 and y == 0) then return nil end
    return WorldPos(mapID, x * 100, y * 100)
end

-- ---------------------------------------------------------------------
-- Mål
-- ---------------------------------------------------------------------
local target = nil -- { continent, wx, wy, label, radius, stepIndex, isTravel }

function Arrow:UpdateTarget()
    local Q = ns.Q
    local step = Q:GetCurrentStep()
    local coords = step and Q:GetStepTarget(step)

    if not step or not coords or not Q.char.ui.arrowShown then
        target = nil
        frame:Hide()
        return
    end

    local continent, wx, wy = WorldPos(coords.map, coords.x, coords.y)
    if not continent then
        target = nil
        frame:Hide()
        return
    end

    target = {
        continent = continent,
        wx = wx,
        wy = wy,
        label = step.label or (step.quests[1] and step.quests[1].title) or L["TYPE_" .. step.type],
        radius = step.radius or 40,
        stepIndex = step.index,
        isTravel = (step.type == "TRAVEL"),
    }
    label:SetText(target.label)
    frame:Show()
end

-- ---------------------------------------------------------------------
-- Løbende opdatering af retning, afstand og farve
-- ---------------------------------------------------------------------
local elapsed = 0
frame:SetScript("OnUpdate", function(_, dt)
    elapsed = elapsed + dt
    if elapsed < 0.05 then return end
    elapsed = 0

    if not target then return end
    local continent, px, py = PlayerWorldPos()
    if not continent then
        distText:SetText("...")
        return
    end

    if continent ~= target.continent then
        arrow:Hide()
        distText:SetText(L.OTHER_CONTINENT)
        return
    end
    arrow:Show()

    -- World-koordinater: +X = nord, +Y = vest. GetPlayerFacing: 0 = nord,
    -- positiv retning mod uret (vest). Samme konvention -> direkte differens.
    local dN, dW = target.wx - px, target.wy - py
    local dist = sqrt(dN * dN + dW * dW)
    local facing = GetPlayerFacing and GetPlayerFacing()

    if facing then
        local rel = atan2(dW, dN) - facing
        arrow:SetRotation(rel)

        -- Farve: grøn når man peger rigtigt, rød når man vender forkert
        local dev = rel % (2 * pi)
        if dev > pi then dev = 2 * pi - dev end
        dev = dev / pi
        local r = dev * 2
        local g = (1 - dev) * 2
        arrow:SetVertexColor(r > 1 and 1 or r, g > 1 and 1 or g, 0)
    end

    if dist < target.radius then
        distText:SetText(L.ARRIVED)
        if target.isTravel then
            local idx = target.stepIndex
            target = nil
            ns.Q:MarkStepDone(idx, true)
        end
    else
        distText:SetFormattedText("%d yd", dist)
    end
end)

function Arrow:SetShown(shown)
    ns.Q.char.ui.arrowShown = shown
    self:UpdateTarget()
end

function Arrow:RestorePosition()
    local pos = ns.Q.char.ui.arrowPos
    if pos then
        frame:ClearAllPoints()
        frame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
    end
end
