local _, ns = ...
local L = ns.L

-- =========================================================================
-- Qeasy Arrow: GPS-pil der peger på det NÆRMESTE ufærdige element i det
-- aktuelle step (a la RestedXP "Follow the Arrow"). Vinkel/afstand regnes
-- i world-koordinater, så pilen virker på tværs af zoner på kontinentet.
-- =========================================================================

local Arrow = {}
ns.Arrow = Arrow

local sqrt, atan2, abs, pi = math.sqrt, math.atan2, math.abs, math.pi

local frame = CreateFrame("Frame", "QeasyArrowFrame", UIParent)
frame:SetSize(150, 108)
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

local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
label:SetPoint("TOP", frame, "TOP", 0, 0)
label:SetWidth(230)
label:SetWordWrap(false)

local arrow = frame:CreateTexture(nil, "ARTWORK")
arrow:SetSize(56, 56)
arrow:SetPoint("TOP", label, "BOTTOM", 0, -2)
arrow:SetTexture("Interface\\AddOns\\Qeasy\\Media\\arrow")

local distText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
distText:SetPoint("TOP", arrow, "BOTTOM", 0, -2)

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
-- Vælg nærmeste ufærdige element med koordinater i det aktuelle step.
-- ---------------------------------------------------------------------
local ICON_LABEL = {
    accept = "Tag", turnin = "Aflever", ["do"] = "Udfør", complete = "Udfør",
    travel = "Rejs", fly = "Flyv", hearth = "Hearth", train = "Træn",
    buy = "Køb", vendor = "Vendor", repair = "Reparér", deliver = "Aflever",
}

local target = nil

function Arrow:PickTarget()
    local Q = ns.Q
    local route = Q:GetActiveRoute()
    local step = Q:GetCurrentStep()
    if not route or not step then return nil end
    local continent, px, py = PlayerWorldPos()

    local best, bestDist
    for _, el in ipairs(step.elements) do
        if not Q:IsElementDone(route, step, el) then
            local coords = Q:ElementTarget(el)
            if coords then
                local c, wx, wy = WorldPos(coords.map, coords.x, coords.y)
                if c then
                    local dist = math.huge -- andet kontinent: fallback-rækkefølge
                    if continent and c == continent then
                        local dN, dW = wx - px, wy - py
                        dist = sqrt(dN * dN + dW * dW)
                    end
                    if not bestDist or dist < bestDist then
                        bestDist = dist
                        best = { el = el, coords = coords, c = c, wx = wx, wy = wy }
                    end
                end
            end
        end
    end
    return best
end

function Arrow:UpdateTarget()
    local Q = ns.Q
    local step = Q:GetCurrentStep()
    if not step or not Q.char.ui.arrowShown then
        target = nil
        frame:Hide()
        return
    end
    local pick = self:PickTarget()
    if not pick then
        target = nil
        frame:Hide()
        return
    end
    local el = pick.el
    local name = (el.q and el.q.title) or el.text or el.label or ICON_LABEL[el.kind] or "?"
    target = {
        continent = pick.c, wx = pick.wx, wy = pick.wy,
        label = (ICON_LABEL[el.kind] or "") .. ": " .. name,
        radius = el.radius or ((el.kind == "travel" or el.kind == "fly") and 40 or 12),
        stepIndex = step.index, elemIndex = el.index,
        autoArrive = (el.kind == "travel" or el.kind == "fly" or el.kind == "hearth"
                      or el.kind == "train" or el.kind == "vendor" or el.kind == "repair"),
    }
    label:SetText(target.label)
    frame:Show()
end

-- ---------------------------------------------------------------------
local elapsed = 0
frame:SetScript("OnUpdate", function(_, dt)
    elapsed = elapsed + dt
    if elapsed < 0.05 then return end
    elapsed = 0
    if not target then return end

    local continent, px, py = PlayerWorldPos()
    if not continent then distText:SetText("...") return end
    if continent ~= target.continent then
        arrow:Hide()
        distText:SetText(L.OTHER_CONTINENT)
        return
    end
    arrow:Show()

    local dN, dW = target.wx - px, target.wy - py
    local dist = sqrt(dN * dN + dW * dW)
    local facing = GetPlayerFacing and GetPlayerFacing()
    if facing then
        local rel = atan2(dW, dN) - facing
        arrow:SetRotation(rel)
        local dev = rel % (2 * pi)
        if dev > pi then dev = 2 * pi - dev end
        dev = dev / pi
        local r, g = dev * 2, (1 - dev) * 2
        arrow:SetVertexColor(r > 1 and 1 or r, g > 1 and 1 or g, 0)
    end

    if dist < target.radius then
        distText:SetText(L.ARRIVED)
        if target.autoArrive then
            local si, ei = target.stepIndex, target.elemIndex
            target = nil
            ns.Q:MarkElementDone(si, ei, true)
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
