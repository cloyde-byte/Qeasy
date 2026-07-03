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

-- onQuest[qid] = complete-bool hvis i loggen, ellers nil.
local function questState(qid)
    return ns.Q.snapshot.onQuest[qid]
end

local function giverAvailable(qid, d)
    if questState(qid) ~= nil then return false end   -- allerede i loggen
    if flagged(qid) then return false end             -- allerede klaret
    if d.lvl and playerLevel() < d.lvl then return false end
    if d.pre then
        for _, p in ipairs(d.pre) do
            if not flagged(p) then return false end
        end
    end
    return true
end

-- Hvilke ikoner skal vises på et bestemt map lige nu?
function Map:IconsForMap(mapID)
    buildIndex()
    ns.Q:ScanQuestLog()
    local list = {}
    for _, e in ipairs(byMap[mapID] or {}) do
        local d = ns.QuestDB[e.qid]
        local show = false
        if e.kind == "giver" then
            show = giverAvailable(e.qid, d)
        elseif e.kind == "turnin" then
            show = (questState(e.qid) == true)      -- i log og færdig
        elseif e.kind == "objective" then
            show = (questState(e.qid) == false)     -- i log, ikke færdig
        end
        if show then
            list[#list + 1] = { qid = e.qid, kind = e.kind, x = e.x, y = e.y, title = d.t }
        end
    end
    return list
end

-- ---------------------------------------------------------------------
-- Ikon-pulje (fælles udseende for kort og minimap)
-- ---------------------------------------------------------------------
local function styleIcon(tex, kind, size)
    tex:SetSize(size, size)
    if kind == "giver" then
        tex:SetTexture(ICON_GIVER)
        tex:SetVertexColor(1, 1, 1)
    elseif kind == "turnin" then
        tex:SetTexture(ICON_TURNIN)
        tex:SetVertexColor(1, 1, 1)
    else
        tex:SetTexture(nil)
        tex:SetColorTexture(0.2, 1.0, 0.2, 0.9)
        tex:SetSize(size * 0.6, size * 0.6)
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
        GameTooltip:AddLine("|cff69ccf0Qeasy|r")
        GameTooltip:AddLine(self.title, 1, 1, 1)
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
        styleIcon(p.tex, ic.kind, 14)
        p:SetSize(14, 14)
        p.title = ic.title
        p.qid = ic.qid
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
                styleIcon(t, ic.kind, 12)
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
