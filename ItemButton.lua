local _, ns = ...

-- =========================================================================
-- Qeasy Item-bar: en sikker klik-knap for hvert quest-item i din taske - fx
-- "Living Fire" til at tænde huts i "Blessing of Incineratus". Bruger
-- Blizzards GetQuestLogSpecialItemInfo (samme kilde som standard-trackeren).
-- Ingen automatik: DU klikker knappen. Secure-knapper må kun opsættes uden
-- for kamp, så opdateringer udskydes til kampen er slut.
-- =========================================================================

local ItemBar = {}
ns.ItemBar = ItemBar

local SIZE, GAP = 38, 4
local HERO_SIZE = 64
local HERO_RADIUS = 200   -- yards: hvor tæt på målet hero-knappen dukker op
local buttons = {}

-- Alle quest-items i loggen lige nu: { {questID, title, link, icon, charges}, ... }
local function specialItems()
    local out = {}
    if not (GetNumQuestLogEntries and GetQuestLogSpecialItemInfo) then return out end
    for i = 1, GetNumQuestLogEntries() do
        local title, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(i)
        if title and not isHeader then
            local link, icon, charges = GetQuestLogSpecialItemInfo(i)
            if link and icon then
                out[#out + 1] = { index = i, questID = questID, title = title,
                                  link = link, icon = icon, charges = charges }
            end
        end
    end
    return out
end

local function worldPos(map, x, y)
    if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then return nil end
    local _, wp = C_Map.GetWorldPosFromMapPos(map, CreateVector2D(x / 100, y / 100))
    if not wp then return nil end
    return wp.x, wp.y
end

-- Kort item-navn fra et hyperlink ("...[Living Fire]..." -> "Living Fire").
local function itemName(link)
    return link and link:match("%[(.-)%]") or "item"
end

local container = CreateFrame("Frame", "QeasyItemBar", UIParent)
container:SetSize(SIZE, SIZE)
container:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 300, -200)
container:SetMovable(true)
container:EnableMouse(true)
container:RegisterForDrag("LeftButton")
container:SetClampedToScreen(true)
container:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
container:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local p, _, _, x, y = self:GetPoint()
    ns.Q.char.ui.itemBarPos = { point = p, x = x, y = y }
end)
container:Hide()

local function getButton(i)
    if buttons[i] then return buttons[i] end
    local b = CreateFrame("Button", "QeasyItemButton" .. i, container, "SecureActionButtonTemplate")
    b:SetSize(SIZE, SIZE)
    b:RegisterForClicks("AnyUp")
    b:SetAttribute("type", "item")

    b.icon = b:CreateTexture(nil, "BACKGROUND")
    b.icon:SetAllPoints(b)
    b.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local border = b:CreateTexture(nil, "OVERLAY")
    border:SetPoint("TOPLEFT", -3, 3)
    border:SetPoint("BOTTOMRIGHT", 3, -3)
    border:SetTexture("Interface\\Buttons\\UI-Quickslot2")

    b.count = b:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    b.count:SetPoint("BOTTOMRIGHT", -3, 3)

    b.cd = CreateFrame("Cooldown", nil, b, "CooldownFrameTemplate")
    b.cd:SetAllPoints(b)

    b:SetScript("OnEnter", function(self)
        if not self.link then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(self.link)
        if self.qtitle then
            GameTooltip:AddLine("|cff69ccf0Qeasy|r: " .. self.qtitle, 0.6, 0.85, 1)
        end
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    buttons[i] = b
    return b
end

function ItemBar:Update()
    if ns.Q.char.ui.itemBar == false then
        for _, b in ipairs(buttons) do b:Hide() end
        container:Hide()
        return
    end
    -- Secure-knapper kan ikke ændres i kamp - udskyd til PLAYER_REGEN_ENABLED.
    if InCombatLockdown and InCombatLockdown() then
        self._pending = true
        return
    end
    self._pending = false

    local shown = 0
    for _, it in ipairs(specialItems()) do
        shown = shown + 1
        local b = getButton(shown)
        b.link = it.link
        b.qtitle = it.title
        b:SetAttribute("item", it.link)
        b.icon:SetTexture(it.icon)
        b.count:SetText((it.charges and it.charges > 1) and it.charges or "")
        if GetQuestLogSpecialItemCooldown and b.cd then
            local start, dur = GetQuestLogSpecialItemCooldown(it.index)
            if start and dur and dur > 0 then b.cd:SetCooldown(start, dur) end
        end
        b:ClearAllPoints()
        b:SetPoint("TOPLEFT", container, "TOPLEFT", 0, -(shown - 1) * (SIZE + GAP))
        b:Show()
    end
    for i = shown + 1, #buttons do buttons[i]:Hide() end

    if shown > 0 then
        container:SetSize(SIZE, shown * (SIZE + GAP) - GAP)
        container:Show()
    else
        container:Hide()
    end

    self:UpdateHero()
end

-- ---------------------------------------------------------------------
-- Hero-knap: en stor, fremhævet klik-knap midt på skærmen, der KUN dukker
-- op når du er tæt på det sted quest-itemet skal bruges (fx Living Fire ved
-- hutsene i "Blessing of Incineratus"). Sikker klik-knap - ingen automatik.
-- ---------------------------------------------------------------------
local hero
local function getHero()
    if hero then return hero end
    local b = CreateFrame("Button", "QeasyHeroButton", UIParent, "SecureActionButtonTemplate")
    b:SetSize(HERO_SIZE, HERO_SIZE)
    b:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
    b:SetFrameStrata("HIGH")
    b:RegisterForClicks("AnyUp")
    b:SetAttribute("type", "item")
    b:SetMovable(true)
    b:RegisterForDrag("LeftButton")
    b:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
    b:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local p, _, _, x, y = self:GetPoint()
        ns.Q.char.ui.heroPos = { point = p, x = x, y = y }
    end)

    b.glow = b:CreateTexture(nil, "BACKGROUND")
    b.glow:SetSize(HERO_SIZE * 1.7, HERO_SIZE * 1.7)
    b.glow:SetPoint("CENTER")
    b.glow:SetTexture("Interface\\AddOns\\Qeasy\\Media\\glow")
    b.glow:SetBlendMode("ADD")

    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetPoint("TOPLEFT", 3, -3)
    b.icon:SetPoint("BOTTOMRIGHT", -3, 3)
    b.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local border = b:CreateTexture(nil, "OVERLAY")
    border:SetPoint("TOPLEFT", -3, 3)
    border:SetPoint("BOTTOMRIGHT", 3, -3)
    border:SetTexture("Interface\\Buttons\\UI-Quickslot2")

    b.count = b:CreateFontString(nil, "OVERLAY", "NumberFontNormalLarge")
    b.count:SetPoint("BOTTOMRIGHT", -3, 4)

    b.label = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    b.label:SetPoint("TOP", b, "BOTTOM", 0, -4)
    b.label:SetTextColor(1, 0.82, 0)

    b.hint = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    b.hint:SetPoint("TOP", b.label, "BOTTOM", 0, -2)
    b.hint:SetTextColor(0.6, 0.85, 1)

    b:SetScript("OnEnter", function(self)
        if not self.link then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(self.link)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    b:Hide()
    hero = b
    return b
end

local function setHeroShown(v)
    local h = getHero()
    if v and not h:IsShown() then h:Show()
    elseif not v and h:IsShown() then h:Hide() end
end

function ItemBar:UpdateHero()
    if ns.Q.char.ui.heroButton == false or ns.Q.char.ui.itemBar == false then
        setHeroShown(false); return
    end
    -- Secure-knap: må ikke ændres i kamp - udskyd visning/opsætning.
    if InCombatLockdown and InCombatLockdown() then self._heroPending = true; return end
    self._heroPending = false

    if not (C_Map and C_Map.GetBestMapForUnit and ns.QuestDB) then setHeroShown(false); return end
    local pmap = C_Map.GetBestMapForUnit("player")
    local ppos = pmap and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(pmap, "player")
    if not ppos then setHeroShown(false); return end
    local px, py = ppos:GetXY()
    local pwx, pwy = worldPos(pmap, (px or 0) * 100, (py or 0) * 100)
    if not pwx then setHeroShown(false); return end

    -- Find det nærmeste quest-item-mål inden for radius.
    local bestD, best
    for _, it in ipairs(specialItems()) do
        local d = ns.QuestDB[it.questID]
        local o = d and d.o
        if o and o[1] == pmap then
            local wx, wy = worldPos(pmap, o[2], o[3])
            if wx then
                local dist = math.sqrt((wx - pwx) ^ 2 + (wy - pwy) ^ 2)
                if dist < HERO_RADIUS and (not bestD or dist < bestD) then
                    bestD, best = dist, it
                end
            end
        end
    end

    local h = getHero()
    if best then
        if h.link ~= best.link then h:SetAttribute("item", best.link) end
        h.link = best.link
        h.icon:SetTexture(best.icon)
        h.count:SetText((best.charges and best.charges > 1) and best.charges or "")
        h.label:SetText(best.title)
        h.hint:SetText("Klik: brug " .. itemName(best.link))
        setHeroShown(true)
    else
        setHeroShown(false)
    end
end

function ItemBar:SetShown(v)
    ns.Q.char.ui.itemBar = v
    self:Update()
end

function ItemBar:SetHeroShown(v)
    ns.Q.char.ui.heroButton = v
    self:UpdateHero()
end

function ItemBar:RestorePosition()
    local pos = ns.Q.char.ui.itemBarPos
    if pos then
        container:ClearAllPoints()
        container:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
    end
    container:SetScale(ns.Q.char.ui.itemBarScale or 1)

    local hp = ns.Q.char.ui.heroPos
    if hp then
        local h = getHero()
        h:ClearAllPoints()
        h:SetPoint(hp.point, UIParent, hp.point, hp.x, hp.y)
    end
end

-- Drivér: tjek jævnligt om vi er kommet tæt på et quest-item-mål, og lad
-- hero-knappens glød pulsere så den er svær at overse.
local driver = CreateFrame("Frame")
local acc, pulseT = 0, 0
driver:SetScript("OnUpdate", function(_, dt)
    pulseT = pulseT + dt
    if hero and hero:IsShown() and hero.glow then
        local s = 1 + 0.16 * (0.5 + 0.5 * math.sin(pulseT * 4))
        hero.glow:SetSize(HERO_SIZE * 1.7 * s, HERO_SIZE * 1.7 * s)
        hero.glow:SetAlpha(0.55 + 0.35 * (0.5 + 0.5 * math.sin(pulseT * 4)))
    end
    acc = acc + dt
    if acc < 0.3 then return end
    acc = 0
    ItemBar:UpdateHero()
end)
