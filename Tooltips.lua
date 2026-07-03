local _, ns = ...
local L = ns.L

-- =========================================================================
-- Qeasy Tooltips: tilføjer linjer til mob/NPC-tooltips, der viser hvilke af
-- DINE aktive quests skabningen tæller til, med fremgang - a la Questie.
-- Matcher skabningens navn mod dine quest-objectives (ingen database behov).
-- =========================================================================

local Tooltips = {}
ns.Tooltips = Tooltips

local lastUnitName = nil

local function addQuestLines(tooltip, name)
    if not ns.Q.char.ui.tooltipsEnabled then return end
    if not name or name == "" then return end
    local hits = ns.QuestLog:ObjectivesForName(name)
    if #hits == 0 then return end
    tooltip:AddLine(" ")
    for _, h in ipairs(hits) do
        local r, g, b = ns.QuestLog:DiffColor(h.level)
        tooltip:AddLine(string.format("|cff69ccf0Qeasy|r [%d] %s", h.level, h.title), r, g, b)
        -- Objektiv-tekst indeholder typisk "Navn slain: 4/10" - vis den grå.
        tooltip:AddLine("   " .. h.text, 0.85, 0.85, 0.85)
    end
    tooltip:Show()
end

local function onUnit(tooltip)
    if tooltip ~= GameTooltip then return end
    local _, unit = tooltip:GetUnit()
    local name = unit and UnitName(unit) or lastUnitName
    if not name and tooltip.GetUnit then
        name = select(1, tooltip:GetUnit())
    end
    addQuestLines(tooltip, name)
end

function Tooltips:Init()
    if self.hooked then return end
    self.hooked = true
    if not GameTooltip then return end

    -- Moderne: OnTooltipSetUnit. Ældre klienter: samme script findes i TBC.
    if GameTooltip.HookScript then
        GameTooltip:HookScript("OnTooltipSetUnit", onUnit)
    end

    -- Fallback: fang navnet via GameTooltip:SetUnit-hook (nogle klienter).
    if hooksecurefunc then
        hooksecurefunc(GameTooltip, "SetUnit", function(self)
            local name = self.GetUnit and select(1, self:GetUnit())
            lastUnitName = name
            addQuestLines(self, name)
        end)
    end
end
