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
local buttons = {}

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
    if not (GetNumQuestLogEntries and GetQuestLogSpecialItemInfo) then
        container:Hide()
        return
    end

    local shown = 0
    local n = GetNumQuestLogEntries()
    for i = 1, n do
        local title, _, _, isHeader = GetQuestLogTitle(i)
        if title and not isHeader then
            local link, icon, charges = GetQuestLogSpecialItemInfo(i)
            if link and icon then
                shown = shown + 1
                local b = getButton(shown)
                b.link = link
                b.qtitle = title
                b:SetAttribute("item", link)
                b.icon:SetTexture(icon)
                b.count:SetText((charges and charges > 1) and charges or "")
                if GetQuestLogSpecialItemCooldown and b.cd then
                    local start, dur = GetQuestLogSpecialItemCooldown(i)
                    if start and dur and dur > 0 then b.cd:SetCooldown(start, dur) end
                end
                b:ClearAllPoints()
                b:SetPoint("TOPLEFT", container, "TOPLEFT", 0, -(shown - 1) * (SIZE + GAP))
                b:Show()
            end
        end
    end
    for i = shown + 1, #buttons do buttons[i]:Hide() end

    if shown > 0 then
        container:SetSize(SIZE, shown * (SIZE + GAP) - GAP)
        container:Show()
    else
        container:Hide()
    end
end

function ItemBar:SetShown(v)
    ns.Q.char.ui.itemBar = v
    self:Update()
end

function ItemBar:RestorePosition()
    local pos = ns.Q.char.ui.itemBarPos
    if pos then
        container:ClearAllPoints()
        container:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
    end
    container:SetScale(ns.Q.char.ui.itemBarScale or 1)
end
