local _, ns = ...

-- =========================================================================
-- Qeasy Map: Questie-agtige quest-ikoner på verdenskortet og minimappet -
-- kun Outland. Data kommer fra ns.QuestDB (Data/OutlandQuests.lua):
--   giver '!'  = quest du KAN tage (ikke i log, ikke klaret, level/pre ok)
--   turn-in '?'= quest i din log der er FÆRDIG (aflever her)
--   objektiv   = quest i din log der ikke er færdig (grøn prik)
-- =========================================================================

local Map = {}
ns.Map = Map

local ICON_GIVER  = "Interface\\GossipFrame\\AvailableQuestIcon"
local ICON_TURNIN = "Interface\\GossipFrame\\ActiveQuestIcon"

-- Zoom-radius i yards (udendørs) pr. Minimap:GetZoom()-trin.
local MM_RADIUS = { [0] = 466.6, [1] = 400.0, [2] = 333.3, [3] = 266.6, [4] = 200.0, [5] = 133.3 }

-- ---------------------------------------------------------------------
-- Indeks: map -> liste af { qid, kind, x, y } (bygges én gang)
-- ---------------------------------------------------------------------
local byMap
local function buildIndex()
    if byMap then return end
    byMap = {}
    if not ns.QuestDB then return end
    for qid, d in pairs(ns.QuestDB) do
        local function add(coord, kind)
            if coord then
                local m = coord[1]
                byMap[m] = byMap[m] or {}
                table.insert(byMap[m], { qid = qid, kind = kind, x = coord[2], y = coord[3] })
            end
        end
        add(d.g, "giver")
        add(d.e, "turnin")
        add(d.o, "objective")
    end
end

-- ---------------------------------------------------------------------
-- Tilstands-hjælpere
-- ---------------------------------------------------------------------
local function playerLevel() return UnitLevel and UnitLevel("player") or 0 end

local function flagged(qid)
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(qid)
    end
    if IsQuestFlaggedCompleted then return IsQuestFlaggedCompleted(qid) end
    return false
end

local function giverAvailable(qid, d)
    if flagged(qid) then return false end             -- allerede klaret
    if d.lvl and playerLevel() < d.lvl then return false end
    if d.pre then
        for _, p in ipairs(d.pre) do
            if not flagged(p) then return false end
        end
    end
    return true
end

-- Byg quest-log-tilstand fra QuestLog (samme robuste "complete"-logik som
-- trackeren: en quest er complete når ALLE objectives er det, også når
-- klientens isComplete-flag mangler - fx redningsquests).
--   st[qid] = "complete" | "active" (i loggen); nil = ikke i loggen
local function buildState()
    local st = {}
    for _, e in ipairs(ns.QuestLog:Scan()) do
        if e.questID then
            st[e.questID] = e.isComplete and "complete" or "active"
        end
    end
    return st
end

-- Hvilke ikoner skal vises på et bestemt map lige nu?
function Map:IconsForMap(mapID)
    buildIndex()
    local st = buildState()
    local list = {}
    for _, e in ipairs(byMap[mapID] or {}) do
        local d = ns.QuestDB[e.qid]
        local state = st[e.qid]
        local show, npc = false, nil
        if e.kind == "giver" then
            show = (state == nil) and giverAvailable(e.qid, d)  -- ikke i loggen
            npc = d.gn
        elseif e.kind == "turnin" then
            show = (state == "complete")                        -- færdig, aflever
            npc = d.en
        elseif e.kind == "objective" then
            show = (state == "active")                          -- i gang
        end
        if show then
            list[#list + 1] = { qid = e.qid, kind = e.kind, x = e.x, y = e.y,
                                title = d.t, npc = npc }
        end
    end
    return list
end

-- ---------------------------------------------------------------------
-- Ikon-pulje (fælles udseende for kort og minimap)
-- ---------------------------------------------------------------------
local ICON_OBJECTIVE = "Interface\\AddOns\\Qeasy\\Media\\objective"

local function styleIcon(tex, kind, size)
    tex:SetSize(size, size)
    tex:SetVertexColor(1, 1, 1)
    if kind == "giver" then
        tex:SetTexture(ICON_GIVER)
    elseif kind == "turnin" then
        tex:SetTexture(ICON_TURNIN)
    else
        tex:SetTexture(ICON_OBJECTIVE)  -- lille tandhjul (pulserer)
    end
end

-- =====================================================================
-- VERDENSKORT
-- =====================================================================
local worldPins = {}

local function worldCanvas()
    local wmf = WorldMapFrame
    if not wmf then return nil end
    if wmf.ScrollContainer and wmf.ScrollContainer.Child then
        return wmf.ScrollContainer.Child
    end
    if wmf.GetCanvas then return wmf:GetCanvas() end
    return nil
end

local function getWorldPin(i, canvas)
    if worldPins[i] then return worldPins[i] end
    local p = CreateFrame("Button", nil, canvas)
    p:SetFrameStrata("HIGH")
    p.tex = p:CreateTexture(nil, "OVERLAY")
    p.tex:SetAllPoints(p)
    p:SetScript("OnEnter", function(self)
        if not self.title then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(self.title, 1, 0.85, 0.30)   -- questnavn, fremhævet
        if self.sub then GameTooltip:AddLine(self.sub, 0.75, 0.82, 0.95) end
        GameTooltip:Show()
    end)
    p:SetScript("OnLeave", function() GameTooltip:Hide() end)
    worldPins[i] = p
    return p
end

function Map:UpdateWorldMap()
    local canvas = worldCanvas()
    if not canvas then return end
    for _, p in ipairs(worldPins) do p:Hide() end
    if not ns.Q.char.ui.mapIcons then return end
    local wmf = WorldMapFrame
    if not (wmf:IsShown() and wmf.GetMapID) then return end
    local mapID = wmf:GetMapID()
    if not mapID then return end

    local w, h = canvas:GetWidth(), canvas:GetHeight()
    if not w or w == 0 then return end
    local n = 0
    for _, ic in ipairs(self:IconsForMap(mapID)) do
        n = n + 1
        local p = getWorldPin(n, canvas)
        local base = (ic.kind == "objective") and 15 or 14
        styleIcon(p.tex, ic.kind, base)
        p:SetSize(base, base)
        p.base = base
        p.isObjective = (ic.kind == "objective")
        p.title = ic.title
        p.qid = ic.qid
        if ic.kind == "turnin" then
            p.sub = "Aflever" .. (ic.npc and (" hos " .. ic.npc) or " her")
        elseif ic.kind == "giver" then
            p.sub = "Tilgængelig quest" .. (ic.npc and (" · " .. ic.npc) or "")
        else
            p.sub = "Objektiv her"
        end
        p:ClearAllPoints()
        p:SetPoint("CENTER", canvas, "TOPLEFT", (ic.x / 100) * w, -(ic.y / 100) * h)
        p:Show()
    end
end

-- =====================================================================
-- MINIMAP
-- =====================================================================
local minimapPins = {}
local mmFrame = CreateFrame("Frame", "QeasyMinimapPins", Minimap)
mmFrame:SetAllPoints(Minimap)

local function worldPos(mapID, x, y)
    if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then return nil end
    local cont, wp = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(x / 100, y / 100))
    if not wp then return nil end
    return cont, wp.x, wp.y
end

local function getMMPin(i)
    if minimapPins[i] then return minimapPins[i] end
    local t = mmFrame:CreateTexture(nil, "OVERLAY")
    minimapPins[i] = t
    return t
end

-- Genberegn hvilke ikoner der er relevante i spillerens nuværende zone.
function Map:Rebuild()
    self.zoneMap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    self.zoneIcons = self.zoneMap and self:IconsForMap(self.zoneMap) or {}
    self:UpdateWorldMap()
end

local elapsed = 0
mmFrame:SetScript("OnUpdate", function(_, dt)
    elapsed = elapsed + dt
    if elapsed < 0.1 then return end
    elapsed = 0
    for _, t in ipairs(minimapPins) do t:Hide() end
    if not ns.Q.char.ui.minimapIcons or not Map.zoneIcons then return end
    if not (C_Map and C_Map.GetBestMapForUnit) then return end
    local map = C_Map.GetBestMapForUnit("player")
    if map ~= Map.zoneMap then Map:Rebuild() end
    if not map then return end
    local pos = C_Map.GetPlayerMapPosition(map, "player")
    if not pos then return end
    local px, py = pos:GetXY()
    if not px or (px == 0 and py == 0) then return end
    local _, pwx, pwy = worldPos(map, px * 100, py * 100)
    if not pwx then return end

    local zoom = Minimap.GetZoom and Minimap:GetZoom() or 3
    local radius = MM_RADIUS[zoom] or 266.6
    local half = (Minimap:GetWidth() or 140) / 2
    local rotate = GetCVar and GetCVar("rotateMinimap") == "1"
    local facing = rotate and GetPlayerFacing and GetPlayerFacing() or 0

    local n = 0
    for _, ic in ipairs(Map.zoneIcons) do
        local _, twx, twy = worldPos(map, ic.x, ic.y)
        if twx then
            local dN, dW = twx - pwx, twy - pwy   -- +N nord, +W vest
            if rotate then
                local cos, sin = math.cos(facing), math.sin(facing)
                dN, dW = dN * cos + dW * sin, -dN * sin + dW * cos
            end
            local dist = math.sqrt(dN * dN + dW * dW)
            if dist < radius * 1.05 then
                n = n + 1
                local t = getMMPin(n)
                local base = (ic.kind == "objective") and 13 or 12
                styleIcon(t, ic.kind, base)
                t.base = base
                t.isObjective = (ic.kind == "objective")
                -- nord = op (+y), vest = venstre (-x)
                local sx = -(dW / radius) * half
                local sy = (dN / radius) * half
                t:ClearAllPoints()
                t:SetPoint("CENTER", Minimap, "CENTER", sx, sy)
                t:Show()
            end
        end
    end
end)

-- ---------------------------------------------------------------------
-- Puls: objektiv-tandhjulene "popper" så de er nemme at få øje på.
-- ---------------------------------------------------------------------
local pulseT = 0
local pulseDriver = CreateFrame("Frame")
pulseDriver:SetScript("OnUpdate", function(_, dt)
    pulseT = pulseT + dt
    local s = 1 + 0.22 * (0.5 + 0.5 * math.sin(pulseT * 5))  -- 1.0 .. 1.22
    for _, p in ipairs(worldPins) do
        if p.isObjective and p:IsShown() then
            local b = p.base or 15
            p:SetSize(b * s, b * s)
        end
    end
    for _, t in ipairs(minimapPins) do
        if t.isObjective and t:IsShown() then
            local b = t.base or 13
            t:SetSize(b * s, b * s)
        end
    end
end)

function Map:Init()
    buildIndex()
    if WorldMapFrame then
        if WorldMapFrame.HookScript then
            WorldMapFrame:HookScript("OnShow", function() Map:UpdateWorldMap() end)
        end
        if hooksecurefunc and WorldMapFrame.OnMapChanged then
            hooksecurefunc(WorldMapFrame, "OnMapChanged", function() Map:UpdateWorldMap() end)
        end
    end
    self:Rebuild()
end
