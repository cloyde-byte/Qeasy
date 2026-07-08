local _, ns = ...

-- =========================================================================
-- Qeasy Links: link quest-navne fra questloggen i chatten (a la Questie).
--
-- TBC-serveren fjerner |Hquest:...|h-hyperlinks fra chat (de bliver til ren
-- tekst hos modtageren). Derfor gør vi som Questie: vi sender KUN ren tekst
-- "[Quest-navn]" (som overlever serveren), og hver Qeasy-klient laver den om
-- til et klikbart link LOKALT via et chat-filter. Alle med Qeasy ser dermed
-- klikbare quest-links; andre ser bare "[Quest-navn]".
-- =========================================================================

local Links = {}
ns.Links = Links

-- Byg et klikbart Qeasy-quest-link (egen |Hqeasy:...|h-type, så klienten ikke
-- afviser det - vi håndterer selv hover-tooltip og klik).
function Links:QuestLink(questID, title, level)
    questID = tonumber(questID) or 0
    level = tonumber(level) or 0
    return string.format("|cffffff00|Hqeasy:%d:%d|h[%s]|h|r", questID, level, tostring(title))
end

-- Indsæt et quest-link i chat-editboxen. Vi indsætter REN tekst "[Titel]", så
-- serveren ikke stripper noget - modtagernes Qeasy laver det om til et link.
function Links:Insert(questID, title, level)
    local text = "[" .. tostring(title) .. "]"
    local eb = ChatEdit_ChooseBoxForSend and ChatEdit_ChooseBoxForSend()
    if eb then
        if not eb:IsShown() then
            if ChatEdit_ActivateChat then ChatEdit_ActivateChat(eb) else eb:Show() end
        end
        eb:Insert(text)
        eb:SetFocus()
    elseif DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(text)
    end
end

-- -------------------------------------------------------------------------
-- Titel-opslag: navn (små bogstaver) -> { id, level }. Bygges fra quest-DB'en,
-- så vi kan genkende ethvert kendt quest-navn i "[...]" i chatten.
-- -------------------------------------------------------------------------
local index
local function buildIndex()
    if index then return index end
    index = {}
    if ns.QuestDB then
        for id, d in pairs(ns.QuestDB) do
            if d.t then index[d.t:lower()] = { id = id, level = d.lvl or 0 } end
        end
    end
    return index
end

-- Slå et navn op og returnér et klikbart link (eller nil hvis ukendt).
local function linkify(title)
    local e = buildIndex()[title:lower()]
    if not e then return nil end
    return Links:QuestLink(e.id, title, e.level)
end

-- Erstat "[Kendt quest]" med et link i et stykke REN tekst (uden hyperlinks).
local function scanPlain(s)
    return (s:gsub("%[([^%[%]]+)%]", function(inner)
        return linkify(inner) or ("[" .. inner .. "]")
    end))
end

-- Lav "[Quest-navn]" om til klikbare links i en besked. Eksisterende hyperlinks
-- (item/enchant/andre) bevares urørt, så vi ikke ødelægger dem.
function Links:Rewrite(msg)
    if not msg or not msg:find("[", 1, true) then return msg end
    local out, pos = {}, 1
    while true do
        local s, e = msg:find("|H.-|h.-|h", pos)
        if not s then
            out[#out + 1] = scanPlain(msg:sub(pos))
            break
        end
        out[#out + 1] = scanPlain(msg:sub(pos, s - 1))
        out[#out + 1] = msg:sub(s, e)          -- behold eksisterende link
        pos = e + 1
    end
    return table.concat(out)
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
                GameTooltip:AddLine((o.done and "|cff20ff20" or "|cffd9d9d9") .. o.text .. "|r")
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

local CHAT_EVENTS = {
    "CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER",
    "CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER_INFORM", "CHAT_MSG_CHANNEL",
    "CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER",
}

function Links:Init()
    if self._inited then return end
    self._inited = true

    local function onEnter(_, link)
        if not link then return end
        local kind, a, b = strsplit(":", link)
        if kind == "qeasy" or kind == "quest" then
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

    -- Chat-filter: lav "[Quest-navn]" om til klikbare links hos ALLE Qeasy-
    -- brugere (også afsenderen selv, når beskeden ekkoer tilbage).
    if ChatFrame_AddMessageEventFilter and not self._filtered then
        self._filtered = true
        local filter = function(_, _, msg, ...)
            return false, Links:Rewrite(msg), ...
        end
        for _, ev in ipairs(CHAT_EVENTS) do
            ChatFrame_AddMessageEventFilter(ev, filter)
        end
    end
end
