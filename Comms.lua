local _, ns = ...

-- =========================================================================
-- Qeasy Comms: deler quest-fremgang mellem party-/raid-medlemmer der kører
-- Qeasy (a la Questies gruppe-sync). Bruger et addon-message-kanal, så det
-- ikke fylder i chatten. Virker Qeasy<->Qeasy (ikke med selve Questie, hvis
-- protokol er udokumenteret og ustabil).
-- =========================================================================

local Comms = {}
ns.Comms = Comms

local PREFIX = "Qeasy"
Comms.party = {}          -- [spillernavn] = { [questID] = "C"|"A"|"cur/tot" }
local lastSent = 0
local lastPayload = nil

function Comms:Init()
    if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
        C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
    elseif RegisterAddonMessagePrefix then
        RegisterAddonMessagePrefix(PREFIX)
    end
end

local function inGroup()
    return IsInGroup and IsInGroup()
end

local function channel()
    if IsInRaid and IsInRaid() then return "RAID" end
    return "PARTY"
end

local function rawSend(msg)
    if C_ChatInfo and C_ChatInfo.SendAddonMessage then
        C_ChatInfo.SendAddonMessage(PREFIX, msg, channel())
    elseif SendAddonMessage then
        SendAddonMessage(PREFIX, msg, channel())
    end
end

-- Sammensæt egne aktive quests til kompakte tokens "qid:progress".
local function myTokens()
    local tokens = {}
    for _, e in ipairs(ns.QuestLog:Scan()) do
        if e.questID then
            local p
            if e.isComplete then
                p = "C"
            elseif #e.objectives == 0 then
                p = "A"
            else
                local cur, tot = 0, 0
                for _, o in ipairs(e.objectives) do
                    local a, b = tostring(o.text):match("(%d+)%s*/%s*(%d+)")
                    if a then
                        cur = cur + tonumber(a); tot = tot + tonumber(b)
                    elseif o.done then
                        cur = cur + 1; tot = tot + 1
                    else
                        tot = tot + 1
                    end
                end
                p = cur .. "/" .. tot
            end
            tokens[#tokens + 1] = e.questID .. ":" .. p
        end
    end
    return tokens
end

-- Send et snapshot af egne quests (chunket, første chunk flagget 'S').
function Comms:Broadcast(force)
    if ns.Q.char.ui.partyShare == false or not inGroup() then return end
    local now = GetTime and GetTime() or 0
    if not force and (now - lastSent) < 3 then return end

    local tokens = myTokens()
    local payload = table.concat(tokens, ";")
    if not force and payload == lastPayload then return end
    lastSent, lastPayload = now, payload

    local first, buf = true, ""
    local function flush()
        rawSend("1" .. (first and "S" or "") .. "|" .. buf)
        first, buf = false, ""
    end
    for _, t in ipairs(tokens) do
        if #buf + #t + 1 > 220 then flush() end
        buf = (buf == "") and t or (buf .. ";" .. t)
    end
    flush()  -- sender også et tomt 'S'-snapshot, så andre rydder gamle data
end

-- Modtag et snapshot fra et party-medlem.
function Comms:OnMessage(prefix, msg, chan, sender)
    if prefix ~= PREFIX then return end
    if not sender then return end
    if Ambiguate then sender = Ambiguate(sender, "short") end
    if UnitName and sender == UnitName("player") then return end  -- ignorér mig selv
    local flags, body = msg:match("^1(%a*)|(.*)$")
    if not flags then return end
    if flags:find("S") then self.party[sender] = {} end
    self.party[sender] = self.party[sender] or {}
    for tok in (body or ""):gmatch("[^;]+") do
        local qid, p = tok:match("(%d+):(.+)")
        if qid then self.party[sender][tonumber(qid)] = p end
    end
    if ns.ObjTracker then ns.ObjTracker:Update() end
end

function Comms:OnRosterChange()
    -- ryd medlemmer der ikke længere er i gruppen, og send eget snapshot
    if not inGroup() then
        wipe(self.party)
    end
    self:Broadcast(true)
end

-- Læsbar fremgang for et quest-id blandt party-medlemmer.
function Comms:ProgressFor(questID)
    local out = {}
    for name, t in pairs(self.party) do
        local p = t[questID]
        if p then
            local txt = (p == "C") and "færdig" or (p == "A") and "taget" or p
            out[#out + 1] = { name = name, text = txt }
        end
    end
    table.sort(out, function(a, b) return a.name < b.name end)
    return out
end

-- =========================================================================
-- Qeasy Announce (valgfrit, default fra): annoncér quest-milepæle til party-
-- chatten - a la Questie. Slå til med "/qeasy announce" (kun i gruppe).
--   * når en quest er klar til aflevering ("- klar til aflevering!")
--   * når en quest bliver AFLEVERET/fuldført ("Fuldførte quest: <navn>!")
-- =========================================================================
local Announce = {}
ns.Announce = Announce
local snap = {}      -- questID -> { complete = bool }
local titles = {}    -- questID -> titel (cache, så vi kender navnet ved turn-in)
local inited = false

local function annChannel()
    if IsInRaid and IsInRaid() then return "RAID" end
    if IsInGroup and IsInGroup() then return "PARTY" end
    return nil
end

local function say(msg)
    local ch = annChannel()
    if ch and SendChatMessage then SendChatMessage("Qeasy: " .. msg, ch) end
end

-- Slå navnet på et quest-id op: helst det vi lige har set i loggen, ellers
-- databasens titel. Faldback til et generisk "en quest".
local function titleFor(questID)
    if titles[questID] then return titles[questID] end
    local d = ns.QuestDB and ns.QuestDB[questID]
    if d and d.t then return d.t end
    return nil
end

-- Kaldes fra QUEST_TURNED_IN. Annoncér at questen er afleveret/fuldført.
function Announce:OnTurnIn(questID)
    questID = tonumber(questID)
    if not ns.Q.char.ui.announceProgress then return end
    local t = questID and titleFor(questID)
    if t then say("Fuldførte quest: " .. t .. "!") end
    if questID then
        snap[questID] = nil
        titles[questID] = nil
    end
end

-- Kaldes fra QUEST_LOG_UPDATE. Opdaterer cache og annoncér "klar til aflevering"
-- første gang en quest bliver komplet (selve afleveringen håndteres i OnTurnIn).
function Announce:Check()
    if not ns.QuestLog then return end
    local first = not inited
    inited = true
    local on = ns.Q.char.ui.announceProgress
    local seen = {}
    for _, e in ipairs(ns.QuestLog:Scan()) do
        if e.questID then
            seen[e.questID] = true
            titles[e.questID] = e.title
            local s = snap[e.questID]
            if on and not first and s and e.isComplete and not s.complete then
                say(e.title .. " - klar til aflevering!")
            end
            snap[e.questID] = { complete = e.isComplete }
        end
    end
    for qid in pairs(snap) do if not seen[qid] then snap[qid] = nil end end
end
