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

-- Peg på den PRIMÆRE fokus-quest (fokus-centreret design). Er quest'en klar til
-- aflevering, peges der på afleverings-NPC'en (d.e); ellers på objektiv-området
-- (d.o). Returnerer nil hvis intet er manuelt fokuseret -> pilen falder tilbage
-- til ruten.
local function flaggedDone(qid)
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(qid)
    end
    if IsQuestFlaggedCompleted then return IsQuestFlaggedCompleted(qid) end
    return false
end

function Arrow:FocusTarget()
    if not (ns.QuestDB and ns.QuestLog) then return nil end
    -- Den primære fokus-quest kan være valgt i trackeren ELLER ved klik på et
    -- kort-ikon (fx et "!"). Den behøver ikke være i loggen endnu: så peger
    -- pilen på questgiveren, så man kan gå hen og tage den.
    local qid = ns.Q.char.ui.primaryFocus
    if qid and (not ns.QuestDB[qid] or flaggedDone(qid)) then
        ns.Q.char.ui.primaryFocus = nil        -- afleveret/ugyldig: ryd
        qid = nil
    end
    if not qid and ns.ObjTracker then
        qid = ns.ObjTracker:PrimaryFocusID()   -- fallback: in-log manuel fokus
    end
    if not qid then return nil end
    local d = ns.QuestDB[qid]
    if not d then return nil end

    -- Tilstand: ikke i loggen / aktiv / complete.
    local state
    for _, e in ipairs(ns.QuestLog:Scan()) do
        if e.questID == qid then state = e.isComplete and "complete" or "active" break end
    end

    local coords, kind
    local function at(t, k) if t then coords, kind = { map = t[1], x = t[2], y = t[3] }, k end end
    if state == nil then
        at(d.g, "accept")                      -- endnu ikke taget: peg på giver
    elseif state == "complete" then
        at(d.e, "turnin"); if not coords then at(d.o, "do") end
    else                                        -- aktiv: peg på objektivet
        at(d.o, "do")
        if not coords and not d.noloc then at(d.e, "turnin") end
    end
    if not coords then return nil end

    local c, wx, wy = WorldPos(coords.map, coords.x, coords.y)
    if not c then return nil end
    return { c = c, wx = wx, wy = wy, kind = kind, name = d.t or "?", coords = coords }
end

-- Koordinater (kort-lokale) som pilen aktuelt peger på - så kortets gyldne sti
-- kan følge fokus-målet i stedet for rutens element.
Arrow.activeCoords = nil

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
    if not Q.char.ui.arrowShown then
        target = nil
        self.activeCoords = nil
        frame:Hide()
        return
    end

    -- 1) Primær fokus vinder (fokus-centreret design). Ingen auto-ankomst, da
    --    målet forsvinder af sig selv når objektivet/afleveringen er fuldført.
    local f = self:FocusTarget()
    if f then
        target = {
            continent = f.c, wx = f.wx, wy = f.wy,
            label = (ICON_LABEL[f.kind] or "") .. ": " .. f.name,
            radius = 12,
        }
        self.activeCoords = f.coords
        label:SetText(target.label)
        frame:Show()
        return
    end

    -- 2) Fallback: rutens nærmeste ufærdige element.
    local step = Q:GetCurrentStep()
    if not step then
        target = nil
        self.activeCoords = nil
        frame:Hide()
        return
    end
    local pick = self:PickTarget()
    if not pick then
        target = nil
        self.activeCoords = nil
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
    self.activeCoords = pick.coords
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
    self:ApplyScale()
end

function Arrow:ApplyScale()
    frame:SetScale(ns.Q.char.ui.arrowScale or 1)
end
