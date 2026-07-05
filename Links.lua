local _, ns = ...

-- =========================================================================
-- Qeasy Links: link quest-navne fra questloggen i chatten (a la Questie).
-- Bruger native WoW `quest:`-hyperlinks, så andre spillere kan klikke dem.
-- Ved hover viser vi et tooltip med objectives + party-fremgang (via Comms).
-- =========================================================================

local Links = {}
ns.Links = Links

-- Byg et klikbart quest-hyperlink. Formatet er WoW's eget `quest:`-link, så
-- det virker for alle spillere (også dem uden Qeasy).
function Links:QuestLink(questID, title, level)
    questID = tonumber(questID) or 0
    level = tonumber(level) or 0
    return string.format("|cffffff00|Hquest:%d:%d|h[%s]|h|r", questID, level, tostring(title))
end

-- Indsæt et quest-link i chat-editboxen (åbner den hvis nødvendigt).
function Links:Insert(questID, title, level)
    local link = self:QuestLink(questID, title, level)
    local eb = ChatEdit_ChooseBoxForSend and ChatEdit_ChooseBoxForSend()
    if eb then
        if not eb:IsShown() then
            if ChatEdit_ActivateChat then ChatEdit_ActivateChat(eb) else eb:Show() end
        end
        eb:Insert(link)
        eb:SetFocus()
    elseif DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(link)
    end
end

-- Vis et tooltip for et quest-hyperlink: titel, objectives (hvis i egen log)
-- og hvor langt party-medlemmer er (fra ns.Comms).
local function showQuestTooltip(questID, title, level)
    GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(title or ("Quest " .. questID), 1, 0.82, 0)
    if level and level > 0 then
        GameTooltip:AddLine("Niveau " .. level, 0.6, 0.6, 0.6)
    end

    -- Egne objectives, hvis questen er i loggen.
    if ns.QuestLog and ns.QuestLog.ObjectivesForID then
        local objs = ns.QuestLog:ObjectivesForID(questID)
        if objs and #objs > 0 then
            GameTooltip:AddLine(" ")
            for _, o in ipairs(objs) do
                local done = o.done
                GameTooltip:AddLine((done and "|cff20ff20" or "|cffd9d9d9") .. o.text .. "|r")
            end
        end
    end

    -- Party-fremgang via Comms.
    if ns.Comms and ns.Comms.ProgressFor then
        local prog = ns.Comms:ProgressFor(questID)
        if prog and #prog > 0 then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cff69ccf0Gruppe:|r")
            for _, p in ipairs(prog) do
                GameTooltip:AddDoubleLine("  " .. p.name, p.text, 0.9, 0.9, 0.9, 0.6, 0.85, 1)
            end
        end
    end
    GameTooltip:Show()
end

function Links:Init()
    if self._inited then return end
    self._inited = true

    local function onEnter(_, link)
        if not link then return end
        local kind, a, b = strsplit(":", link)
        if kind == "quest" then
            local qid = tonumber(a) or 0
            local level = tonumber(b) or 0
            local title
            if ns.QuestDB and ns.QuestDB[qid] then title = ns.QuestDB[qid].t end
            if not title and ns.QuestLog and ns.QuestLog.TitleForID then
                title = ns.QuestLog:TitleForID(qid)
            end
            showQuestTooltip(qid, title, level)
        end
    end
    local function onLeave()
        GameTooltip:Hide()
    end

    -- Hook alle chat-frames' hyperlink-hændelser (uden at pille ved deres felter).
    self.hooked = self.hooked or {}
    for i = 1, (NUM_CHAT_WINDOWS or 10) do
        local cf = _G["ChatFrame" .. i]
        if cf and not self.hooked[cf] then
            self.hooked[cf] = true
            cf:HookScript("OnHyperlinkEnter", onEnter)
            cf:HookScript("OnHyperlinkLeave", onLeave)
        end
    end
end
