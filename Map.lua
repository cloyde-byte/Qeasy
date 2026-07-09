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
local ICON_FLIGHT = "Interface\\Icons\\Ability_Mount_Gryphon_01"
local ICON_INN    = "Interface\\Minimap\\Tracking\\Innkeeper"
local ICON_MAIL   = "Interface\\Minimap\\Tracking\\Mailbox"

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

-- Alliance-/draenei-hubs, hvor en Horde-spiller ikke skal se tilgængelige
-- quests (deres givere er draenei/Broken). Geo-fence: giver-koordinat inden
-- for radius (zone-%) af hub-centrum. {map, x, y, r}.
local ALLIANCE_HUBS = {
    { 1946, 68.2, 49.8, 4.0 },   -- Telredor (Zangarmarsh)
    { 1946, 41.9, 28.8, 4.0 },   -- Orebor Harborage (Zangarmarsh)
}
local function atAllianceHub(d)
    local g = d.g
    if not g then return false end
    for _, h in ipairs(ALLIANCE_HUBS) do
        if g[1] == h[1] then
            local dx, dy = g[2] - h[2], g[3] - h[3]
            if dx * dx + dy * dy <= h[4] * h[4] then return true end
        end
    end
    return false
end

local function flagged(qid)
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(qid)
    end
    if IsQuestFlaggedCompleted then return IsQuestFlaggedCompleted(qid) end
    return false
end

local function giverAvailable(qid, d)
    if flagged(qid) then return false end             -- allerede klaret
    if atAllianceHub(d) then return false end         -- Alliance-by (Telredor/Orebor)
    -- Sæson-event: skjul quest-giveren uden for eventets datovindue.
    if d.ev and ns.Seasonal and not ns.Seasonal:IsActive(d.ev) then return false end
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
                                title = d.t, npc = npc, otype = d.ot,
                                oa = (e.kind == "objective") and d.oa or nil }
        end
    end
    return list
end

-- ---------------------------------------------------------------------
-- Ikon-pulje (fælles udseende for kort og minimap)
-- ---------------------------------------------------------------------
local ICON_OBJECTIVE   = "Interface\\AddOns\\Qeasy\\Media\\objective"    -- tandhjul (interager)
local ICON_SLAY        = "Interface\\AddOns\\Qeasy\\Media\\slay"         -- krydsede sværd (dræb)
local ICON_FLIGHTPOINT = "Interface\\AddOns\\Qeasy\\Media\\flightpoint"  -- grønt "!" (mangler)
local ICON_BANG_RED    = "Interface\\AddOns\\Qeasy\\Media\\bang_red"     -- rødt "!" (PvP)
local ICON_BANG_BLUE   = "Interface\\AddOns\\Qeasy\\Media\\bang_blue"    -- blåt "!" (gentagelig)

-- Er en quest PvP ('pvp') eller gentagelig ('repeat')? (kurateret liste)
local function questFlag(qid) return ns.QuestFlags and ns.QuestFlags[qid] end

-- Omvendt indeks: quest-giver-navn -> liste af quest-id'er (bygges én gang).
local giverByName
local function buildGiverIndex()
    if giverByName then return end
    giverByName = {}
    if not ns.QuestDB then return end
    for qid, d in pairs(ns.QuestDB) do
        if d.gn then
            giverByName[d.gn] = giverByName[d.gn] or {}
            table.insert(giverByName[d.gn], qid)
        end
    end
end

-- Hvilke TILGÆNGELIGE quests giver NPC'en `name`? (til mob/NPC-tooltips, så
-- man kan se hvad en questgiver har uden at åbne kortet - a la Questie).
function Map:AvailableQuestsForGiver(name)
    buildGiverIndex()
    local out = {}
    local list = name and giverByName[name]
    if not list then return out end
    local inLog = {}
    for _, e in ipairs(ns.QuestLog:Scan()) do
        if e.questID then inLog[e.questID] = true end
    end
    for _, qid in ipairs(list) do
        local d = ns.QuestDB[qid]
        if not inLog[qid] and giverAvailable(qid, d) then
            out[#out + 1] = { qid = qid, title = d.t, level = d.lvl or 0, flag = questFlag(qid) }
        end
    end
    table.sort(out, function(a, b) return a.level < b.level end)
    return out
end

-- Er et objektiv et "dræb"-mål? (otype 'u' fra pfQuest = enheder).
local function isSlay(otype) return otype == "u" end

-- Under-tekst til et objektiv-ikon: hvilke mobs skal dræbes (fra DB'ens ou).
local function objectiveSub(qid, otype)
    local d = ns.QuestDB and ns.QuestDB[qid]
    local ou = d and d.ou
    if ou and #ou > 0 then
        local n = math.min(3, #ou)
        local names = {}
        for i = 1, n do names[i] = ou[i] end
        local s = table.concat(names, ", ")
        if #ou > n then s = s .. " m.fl." end
        return "Dræb: " .. s
    end
    return isSlay(otype) and "Dræb-mål her" or "Objektiv her"
end

local function styleIcon(tex, kind, size, otype, known, flag)
    tex:SetSize(size, size)
    tex:SetVertexColor(1, 1, 1)
    if kind == "giver" then
        -- PvP = rødt "!", gentagelig = blåt "!", ellers standard gult "!".
        tex:SetTexture(flag == "pvp" and ICON_BANG_RED
            or flag == "repeat" and ICON_BANG_BLUE
            or ICON_GIVER)
    elseif kind == "turnin" then
        tex:SetTexture(ICON_TURNIN)
    elseif kind == "flightmaster" then
        -- Kendt flyvemester = gryf-ikon; uopdaget = grønt "!" (gå hen og tag den).
        tex:SetTexture(known and ICON_FLIGHT or ICON_FLIGHTPOINT)
    elseif kind == "innkeeper" then
        tex:SetTexture(ICON_INN)
    elseif kind == "mailbox" then
        tex:SetTexture(ICON_MAIL)
    elseif isSlay(otype) then
        tex:SetTexture(ICON_SLAY)       -- dræb-quest = røde krydsede sværd
    else
        tex:SetTexture(ICON_OBJECTIVE)  -- interager/saml = tandhjul (pulserer)
    end
end

-- Opdagede flyvemestre (per karakter): [navn] = true. Læres når du kommer
-- tæt på en flyvemester eller åbner dens rejsekort (se Learn* nedenfor).
local function knownFlights()
    ns.Q.char.knownFlights = ns.Q.char.knownFlights or {}
    return ns.Q.char.knownFlights
end

-- Flight masters på et bestemt map (fra ns.FlightMasters).
function Map:FlightMastersForMap(mapID)
    local list = {}
    local fms = ns.FlightMasters and ns.FlightMasters[mapID]
    local known = knownFlights()
    if fms then
        for _, fm in ipairs(fms) do
            list[#list + 1] = { kind = "flightmaster", x = fm[1], y = fm[2],
                                title = fm[3], horde = fm[4], known = known[fm[3]] }
        end
    end
    return list
end

-- ---------------------------------------------------------------------
-- Klyngedannelse: flere ikoner af samme slags oven på hinanden (fx flere
-- quests hos samme questgiver) samles til ÉT pin, så de ikke skjuler
-- hinanden. Tooltip'et lister så alle quests på stedet (a la Questie).
-- ---------------------------------------------------------------------
local function visualClass(ic)
    if ic.kind == "objective" then
        return isSlay(ic.otype) and "obj-slay" or "obj-gear"
    elseif ic.kind == "flightmaster" then
        return ic.known and "fm-known" or "fm-new"
    end
    return ic.kind
end

local function clusterHeader(kind)
    if kind == "giver" then return "Tilgængelige quests her:" end
    if kind == "turnin" then return "Aflever her:" end
    if kind == "flightmaster" then return "Flyvemestre her:" end
    if kind == "innkeeper" then return "Kroværter her:" end
    if kind == "mailbox" then return "Postkasser her:" end
    return "Mål her:"
end

function Map:ClusterIcons(list)
    local clusters, index = {}, {}
    for _, ic in ipairs(list) do
        local key = string.format("%s:%d:%d", visualClass(ic),
            math.floor(ic.x / 1.5 + 0.5), math.floor(ic.y / 1.5 + 0.5))
        local c = index[key]
        if not c then
            c = { kind = ic.kind, x = ic.x, y = ic.y, otype = ic.otype,
                  known = ic.known, horde = ic.horde, qid = ic.qid,
                  title = ic.title, npc = ic.npc, entries = {} }
            index[key] = c
            clusters[#clusters + 1] = c
        end
        c.entries[#c.entries + 1] = { title = ic.title, npc = ic.npc }
    end
    return clusters
end

-- Kroværter og postkasser på et bestemt map (fra ns.POI) - a la Questie.
function Map:POIForMap(mapID)
    local list = {}
    if not ns.POI then return list end
    for _, ik in ipairs((ns.POI.innkeepers and ns.POI.innkeepers[mapID]) or {}) do
        list[#list + 1] = { kind = "innkeeper", x = ik[1], y = ik[2], title = ik[3] }
    end
    for _, mb in ipairs((ns.POI.mailboxes and ns.POI.mailboxes[mapID]) or {}) do
        list[#list + 1] = { kind = "mailbox", x = mb[1], y = mb[2], title = "Postkasse" }
    end
    return list
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

-- Løft et pin over kortets egne POI'er. GØRES HVER opdatering (ikke kun ved
-- oprettelse), for kortets strata/frame-level skifter når det maksimeres, og
-- Blizzards POI-pins (fx Ring of Trials-arenaen) ligger højt i frame-level.
local function raisePin(p, canvas)
    if canvas.GetFrameStrata then p:SetFrameStrata(canvas:GetFrameStrata()) end
    local lvl = (canvas.GetFrameLevel and canvas:GetFrameLevel() or 0) + 2500
    p:SetFrameLevel(lvl)
end

local function getWorldPin(i, canvas)
    if worldPins[i] then return worldPins[i] end
    local p = CreateFrame("Button", nil, canvas)
    p.tex = p:CreateTexture(nil, "OVERLAY")
    p.tex:SetDrawLayer("OVERLAY", 7)
    p.tex:SetAllPoints(p)
    p:SetScript("OnEnter", function(self)
        if not self.title then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if self.count and self.count > 1 then
            -- Flere quests/mål på samme sted: list dem alle.
            GameTooltip:AddLine(clusterHeader(self.kind), 1, 0.85, 0.30)
            for _, e in ipairs(self.entries) do
                local line = "• " .. (e.title or "")
                if e.npc then line = line .. "  |cff9fb8cc(" .. e.npc .. ")|r" end
                GameTooltip:AddLine(line, 0.9, 0.9, 0.9)
            end
        else
            GameTooltip:AddLine(self.title, 1, 0.85, 0.30)   -- questnavn, fremhævet
            if self.sub then GameTooltip:AddLine(self.sub, 0.75, 0.82, 0.95) end
        end
        GameTooltip:Show()
    end)
    p:SetScript("OnLeave", function() GameTooltip:Hide() end)
    worldPins[i] = p
    return p
end

-- Spawn-område-markering: en sky af bløde blå pletter, der viser HVOR målets
-- mobs står (fx alle clefthoof for "Clefthoof Mastery"), i stedet for kun ét
-- sværd. Pletterne ligger under quest-ikonerne.
-- Farver til op til 3 fokuserede quests' spawn-skyer (alle blålige, men
-- adskillelige - fx Talbuk vs Clefthoof vs Windroc).
local AREA_COLORS = {
    { 0.22, 0.51, 1.00 },   -- blå
    { 0.20, 0.82, 0.95 },   -- cyan
    { 0.58, 0.45, 1.00 },   -- indigo
}
local areaHost, areaMarks, areaLines = nil, {}, {}
local function ensureAreaHost(canvas)
    if not areaHost or (areaHost.GetParent and areaHost:GetParent() ~= canvas) then
        areaHost = CreateFrame("Frame", nil, canvas)
        areaMarks, areaLines = {}, {}
    end
    return areaHost
end
local function getAreaMark(i, canvas)
    ensureAreaHost(canvas)
    if areaMarks[i] then return areaMarks[i] end
    local t = areaHost:CreateTexture(nil, "ARTWORK")
    t:SetTexture("Interface\\AddOns\\Qeasy\\Media\\blob")
    t:SetBlendMode("BLEND")             -- normal alpha (ADD gav hvid blowout)
    t:SetVertexColor(0.22, 0.51, 1.0)   -- gennemsigtig blå
    t:SetAlpha(0.30)
    areaMarks[i] = t
    return t
end
-- Waypoint-linje (fra dig til et fokuseret mål) - a la Questie. Bruger en
-- roteret tekstur i stedet for CreateLine (virker på alle klient-versioner).
local function getAreaLine(i, canvas)
    ensureAreaHost(canvas)
    if areaLines[i] then return areaLines[i] end
    local t = areaHost:CreateTexture(nil, "OVERLAY")
    t:SetTexture("Interface\\Buttons\\WHITE8X8")
    areaLines[i] = t
    return t
end

-- Lys gylden farve til hoved-stien (mod GPS-pilens mål).
local TRAIL_COLOR = { 1.0, 0.86, 0.25 }

-- Mål for de prikkede stier på et bestemt kort. To kilder:
--   1) GPS-pilens AKTUELLE mål (det step du lige nu bliver ledt til) - findes
--      altid når du følger ruten, uden at du skal fokusere noget. Gylden sti.
--   2) De fokuserede quests i trackeren (op til 3) - hver i sin blå nuance,
--      så de matcher spawn-skyerne.
function Map:PathTargets(mapID)
    local out = {}
    local seen = {}
    local function add(x, y, color)
        if not x then return end
        local key = math.floor(x * 4) .. ":" .. math.floor(y * 4)
        if seen[key] then return end
        seen[key] = true
        out[#out + 1] = { x = x, y = y, color = color }
    end

    -- 1) Pilens mål (samme punkt pilen peger på).
    local pick = ns.Arrow and ns.Arrow.PickTarget and ns.Arrow:PickTarget()
    if pick and pick.coords and pick.coords.map == mapID then
        add(pick.coords.x, pick.coords.y, TRAIL_COLOR)
    end

    -- 2) Fokuserede quests' objektiv-centroider.
    local focus = ns.ObjTracker and ns.ObjTracker.FocusList and ns.ObjTracker:FocusList()
    if focus then
        for i, qid in ipairs(focus) do
            local d = ns.QuestDB and ns.QuestDB[qid]
            if d and d.o and d.o[1] == mapID then
                add(d.o[2], d.o[3], AREA_COLORS[i] or AREA_COLORS[1])
            end
        end
    end
    return out
end

-- Bagudkompatibelt alias (bruges af ældre kald/tests).
function Map:FocusPathTargets(mapID)
    return self:PathTargets(mapID)
end

function Map:UpdateWorldMap()
    local canvas = worldCanvas()
    if not canvas then return end
    for _, p in ipairs(worldPins) do p:Hide() end
    local wmf = WorldMapFrame
    if not (wmf and wmf:IsShown() and wmf.GetMapID) then return end
    local mapID = wmf:GetMapID()
    if not mapID then return end

    local w, h = canvas:GetWidth(), canvas:GetHeight()
    if not w or w == 0 then return end

    local list = {}
    if ns.Q.char.ui.mapIcons ~= false then
        for _, ic in ipairs(self:IconsForMap(mapID)) do list[#list + 1] = ic end
    end
    if ns.Q.char.ui.flightMasters ~= false then
        for _, fm in ipairs(self:FlightMastersForMap(mapID)) do list[#list + 1] = fm end
    end
    if ns.Q.char.ui.poiIcons ~= false then
        for _, p in ipairs(self:POIForMap(mapID)) do list[#list + 1] = p end
    end

    -- Spawn-områder (blå skyer) - KUN for de quests du er fokuseret på i
    -- trackeren (op til 3), hver i sin nuance. Tegnes UNDER ikonerne.
    local am = 0
    local focus = ns.ObjTracker and ns.ObjTracker.FocusList and ns.ObjTracker:FocusList()
    if ns.Q.char.ui.mapIcons ~= false and ns.Q.char.ui.spawnAreas ~= false and focus and #focus > 0 then
        local colorOf = {}                       -- qid -> farve efter fokus-rækkefølge
        for i, qid in ipairs(focus) do colorOf[qid] = AREA_COLORS[i] or AREA_COLORS[1] end
        local size = math.max(24, w * 0.06)      -- skalerer med zoom
        for _, ic in ipairs(list) do
            local col = ic.oa and colorOf[ic.qid]
            if col then
                for _, pt in ipairs(ic.oa) do
                    am = am + 1
                    local t = getAreaMark(am, canvas)
                    t:SetSize(size, size)
                    t:SetVertexColor(col[1], col[2], col[3])
                    t:ClearAllPoints()
                    t:SetPoint("CENTER", canvas, "TOPLEFT", (pt[1] / 100) * w, -(pt[2] / 100) * h)
                    t:Show()
                end
            end
        end
        if am > 0 and areaHost then   -- løft skyerne over kortet (men under ikonerne)
            if canvas.GetFrameStrata then areaHost:SetFrameStrata(canvas:GetFrameStrata()) end
            areaHost:SetFrameLevel((canvas.GetFrameLevel and canvas:GetFrameLevel() or 0) + 2400)
        end
    end
    for i = am + 1, #areaMarks do areaMarks[i]:Hide() end

    local n = 0
    for _, ic in ipairs(self:ClusterIcons(list)) do
        n = n + 1
        local p = getWorldPin(n, canvas)
        raisePin(p, canvas)
        -- Lidt mindre ikoner end før (særligt sværd/tandhjul). Kendt flyvemester
        -- vises mindre (gryf); uopdaget flyvemester som et tydeligt grønt "!".
        local base = (ic.kind == "flightmaster") and (ic.known and 12 or 14)
            or (ic.kind == "objective") and (isSlay(ic.otype) and 13 or 12)
            or (ic.kind == "innkeeper" or ic.kind == "mailbox") and 14
            or (ic.kind == "turnin") and 16   -- afleverings-"?" større: let at finde
            or 13
        styleIcon(p.tex, ic.kind, base, ic.otype, ic.known,
            ic.kind == "giver" and questFlag(ic.qid) or nil)
        p:SetSize(base, base)
        p.base = base
        -- Tandhjul (interager/saml) OG afleverings-"?" pulserer, så de skiller sig
        -- ud i en tæt by; sværd/"!" står stille.
        p.pulse = ic.kind == "turnin"
            or ((ic.kind == "objective") and not isSlay(ic.otype))
        p.title = ic.title
        p.qid = ic.qid
        p.kind = ic.kind
        p.entries = ic.entries
        p.count = ic.entries and #ic.entries or 1
        if ic.kind == "turnin" then
            p.sub = "Aflever" .. (ic.npc and (" hos " .. ic.npc) or " her")
        elseif ic.kind == "giver" then
            local fl = questFlag(ic.qid)
            local tag = fl == "pvp" and "PvP-quest" or fl == "repeat" and "Gentagelig quest"
                or "Tilgængelig quest"
            p.sub = tag .. (ic.npc and (" · " .. ic.npc) or "")
        elseif ic.kind == "flightmaster" then
            local fac = ic.horde and "Horde" or "neutral"
            p.sub = ic.known and ("Flyvemester (" .. fac .. ")")
                or ("Ny flyvemester her (" .. fac .. ") · mangler")
        elseif ic.kind == "innkeeper" then
            p.sub = "Kroværter (sæt hearthstone)"
        elseif ic.kind == "mailbox" then
            p.sub = "Postkasse"
        else   -- objektiv (dræb/interager): vis mob-navne hvis vi har dem
            p.sub = objectiveSub(ic.qid, ic.otype)
        end
        p:ClearAllPoints()
        p:SetPoint("CENTER", canvas, "TOPLEFT", (ic.x / 100) * w, -(ic.y / 100) * h)
        p:Show()
    end

    -- Waypoint-linjer TIL SIDST (og crash-sikret), så en fejl i linje-API'et
    -- aldrig kan forhindre selve quest-ikonerne i at blive tegnet.
    self:DrawFocusLines(canvas, mapID, w, h)
end

-- Farvet linje fra din position til hvert fokuseret mål (samme farve som
-- skyen). Pakket ind i pcall, da CreateLine/SetStartPoint varierer lidt
-- mellem klientversioner.
-- Prikket sti fra dig til hvert fokuseret mål. Vi bruger en RÆKKE små prikker
-- i stedet for én roteret tekstur, fordi SetRotation klipper lange, tynde
-- teksturer til deres akse-rettede kasse (så en skrå linje forsvinder).
function Map:DrawFocusLines(canvas, mapID, w, h)
    local dn = 0
    pcall(function()
        if ns.Q.char.ui.mapIcons == false then return end
        if not (canvas.CreateTexture and C_Map and C_Map.GetBestMapForUnit) then return end
        -- Stien tegnes kun på kortet for den zone du STÅR i (ikke når du
        -- kigger på en anden zone) - så prikkerne peger fra din faktiske plads.
        if C_Map.GetBestMapForUnit("player") ~= mapID then return end
        local ppos = C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(mapID, "player")
        local px, py = ppos and ppos:GetXY()
        if not px or (px == 0 and py == 0) then return end
        local x1, y1 = px * w, -py * h                       -- kanvas-pixel (TOPLEFT-anker)
        for _, tgt in ipairs(self:PathTargets(mapID)) do
            local c = tgt.color
            local x2, y2 = (tgt.x / 100) * w, -(tgt.y / 100) * h
            local dx, dy = x2 - x1, y2 - y1
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist > 6 then
                local count = math.min(80, math.max(2, math.floor(dist / 14)))  -- prik pr. ~14 px
                for k = 1, count - 1 do                        -- spring endepunkterne over
                    local t = k / count
                    dn = dn + 1
                    local dot = getAreaLine(dn, canvas)
                    dot:SetVertexColor(c[1], c[2], c[3], 0.95)
                    dot:SetSize(6, 6)
                    dot:ClearAllPoints()
                    dot:SetPoint("CENTER", canvas, "TOPLEFT", x1 + dx * t, y1 + dy * t)
                    dot:Show()
                end
            end
        end
        if dn > 0 and areaHost then    -- løft prikkerne over kortet (under ikonerne)
            if canvas.GetFrameStrata then areaHost:SetFrameStrata(canvas:GetFrameStrata()) end
            areaHost:SetFrameLevel((canvas.GetFrameLevel and canvas:GetFrameLevel() or 0) + 2450)
        end
    end)
    for i = dn + 1, #areaLines do
        if areaLines[i] then areaLines[i]:Hide() end
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

-- Genberegn hvilke ikoner der er relevante i spillerens nuværende zone
-- (quest-ikoner + flight masters, hver styret af sin toggle).
function Map:Rebuild()
    self.zoneMap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local icons = {}
    if self.zoneMap then
        if ns.Q.char.ui.minimapIcons ~= false then
            for _, ic in ipairs(self:IconsForMap(self.zoneMap)) do icons[#icons + 1] = ic end
        end
        if ns.Q.char.ui.flightMasters ~= false then
            for _, fm in ipairs(self:FlightMastersForMap(self.zoneMap)) do icons[#icons + 1] = fm end
        end
        if ns.Q.char.ui.poiIcons ~= false then
            for _, p in ipairs(self:POIForMap(self.zoneMap)) do icons[#icons + 1] = p end
        end
    end
    self.zoneIcons = self:ClusterIcons(icons)
    self:UpdateWorldMap()
end

local elapsed = 0
mmFrame:SetScript("OnUpdate", function(_, dt)
    elapsed = elapsed + dt
    if elapsed < 0.1 then return end
    elapsed = 0
    for _, t in ipairs(minimapPins) do t:Hide() end
    if not Map.zoneIcons then return end  -- toggles er allerede anvendt i Rebuild
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
            -- Auto-lær flyvemestre du kommer tæt på (≈opdagelses-afstand).
            if ic.kind == "flightmaster" and not ic.known and dist < 40 then
                knownFlights()[ic.title] = true
                Map._flightsDirty = true
            end
            if dist < radius * 1.05 then
                n = n + 1
                local t = getMMPin(n)
                local base = (ic.kind == "flightmaster") and (ic.known and 10 or 12)
                    or (ic.kind == "objective") and (isSlay(ic.otype) and 12 or 11)
                    or (ic.kind == "innkeeper" or ic.kind == "mailbox") and 13 or 12
                styleIcon(t, ic.kind, base, ic.otype, ic.known,
                    ic.kind == "giver" and questFlag(ic.qid) or nil)
                t.base = base
                t.pulse = (ic.kind == "objective") and not isSlay(ic.otype)
                -- nord = op (+y), vest = venstre (-x)
                local sx = -(dW / radius) * half
                local sy = (dN / radius) * half
                t:ClearAllPoints()
                t:SetPoint("CENTER", Minimap, "CENTER", sx, sy)
                t:Show()
            end
        end
    end

    -- Lærte vi en ny flyvemester? Genopbyg, så "!" bliver til gryf-ikonet.
    if Map._flightsDirty then Map._flightsDirty = false; Map:Rebuild() end
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
        if p.pulse and p:IsShown() then
            local b = p.base or 12
            p:SetSize(b * s, b * s)
        end
    end
    for _, t in ipairs(minimapPins) do
        if t.pulse and t:IsShown() then
            local b = t.base or 11
            t:SetSize(b * s, b * s)
        end
    end
end)

-- Når du åbner en flyvemesters rejsekort står du oven i den: markér den
-- nærmeste kendte flyvemester i din zone som opdaget (præcist og sikkert).
function Map:LearnFlightsFromTaxi()
    if not (C_Map and C_Map.GetBestMapForUnit) then return end
    local pmap = C_Map.GetBestMapForUnit("player")
    local fms = pmap and ns.FlightMasters and ns.FlightMasters[pmap]
    if not fms then return end
    local pos = C_Map.GetPlayerMapPosition(pmap, "player")
    if not pos then return end
    local px, py = pos:GetXY()
    if not px then return end
    local _, pwx, pwy = worldPos(pmap, px * 100, py * 100)
    if not pwx then return end

    local bestD, bestName
    for _, fm in ipairs(fms) do
        local _, wx, wy = worldPos(pmap, fm[1], fm[2])
        if wx then
            local d = (wx - pwx) ^ 2 + (wy - pwy) ^ 2
            if not bestD or d < bestD then bestD, bestName = d, fm[3] end
        end
    end
    if bestName and not knownFlights()[bestName] then
        knownFlights()[bestName] = true
        self:Rebuild()
    end
end

function Map:Init()
    buildIndex()
    if WorldMapFrame then
        if WorldMapFrame.HookScript then
            WorldMapFrame:HookScript("OnShow", function() Map:UpdateWorldMap() end)
            -- Maksimering/minimering ændrer størrelse OG strata -> gen-tegn,
            -- så ikonerne løftes korrekt over kortet igen.
            WorldMapFrame:HookScript("OnSizeChanged", function() Map:UpdateWorldMap() end)
        end
        if hooksecurefunc and WorldMapFrame.OnMapChanged then
            hooksecurefunc(WorldMapFrame, "OnMapChanged", function() Map:UpdateWorldMap() end)
        end
    end
    self:Rebuild()
end
