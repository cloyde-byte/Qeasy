local _, ns = ...

-- =========================================================================
-- Qeasy QuestLog: læser spillerens LIVE quest-log (uafhængigt af ruten) til
-- brug for quest-trackeren og mob-tooltips - a la Questie. Bruger kun
-- klientens API, så det virker for alle quests (også dem uden for ruten).
-- =========================================================================

local QuestLog = {}
ns.QuestLog = QuestLog

-- Scan quest-loggen til en ordnet liste af poster:
--   { isHeader = true, name = "Zone" }
--   { questID=, title=, level=, isComplete=, objectives = { {text=, done=}, ... } }
function QuestLog:Scan()
    local out = {}
    if not (GetNumQuestLogEntries and GetQuestLogTitle) then return out end
    local n = GetNumQuestLogEntries()
    for i = 1, n do
        local title, level, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(i)
        if isHeader then
            out[#out + 1] = { isHeader = true, name = title or "" }
        elseif title then
            local objectives = {}
            local allDone = true
            local numObj = GetNumQuestLeaderBoards and GetNumQuestLeaderBoards(i) or 0
            for j = 1, numObj do
                local text, _, finished = GetQuestLogLeaderBoard(j, i)
                if text and text ~= "" then
                    objectives[#objectives + 1] = { text = text, done = finished and true or false }
                    if not finished then allDone = false end
                end
            end
            local complete = (isComplete == 1) or (isComplete == true)
                or (numObj > 0 and allDone) or (numObj == 0 and isComplete ~= nil)
            out[#out + 1] = {
                questID = questID, title = title, level = level or 0,
                isComplete = complete, objectives = objectives,
            }
        end
    end
    return out
end

-- Antal quests (i alt / fuldførte) til overskriften.
function QuestLog:Counts()
    local total, done = 0, 0
    for _, e in ipairs(self:Scan()) do
        if e.questID then
            total = total + 1
            if e.isComplete then done = done + 1 end
        end
    end
    return done, total
end

-- Sværhedsgrad-farve for et quest-level (relativt til spilleren).
function QuestLog:DiffColor(level)
    if GetQuestDifficultyColor then
        local c = GetQuestDifficultyColor(level)
        if c then return c.r, c.g, c.b end
    end
    -- Fallback: grov farvning ud fra forskellen til spillerens level.
    local pl = UnitLevel and UnitLevel("player") or level
    local d = level - pl
    if d >= 5 then return 1.0, 0.1, 0.1
    elseif d >= 3 then return 1.0, 0.5, 0.25
    elseif d >= -2 then return 1.0, 0.82, 0.0
    elseif d >= -7 then return 0.25, 0.75, 0.25
    else return 0.6, 0.6, 0.6 end
end

-- Objectives for et bestemt quest-id (hvis questen er i loggen).
-- Returnerer { {text=, done=}, ... } eller nil.
function QuestLog:ObjectivesForID(questID)
    for _, e in ipairs(self:Scan()) do
        if e.questID == questID then return e.objectives end
    end
    return nil
end

-- Titel for et quest-id fra loggen (hvis questen er i loggen).
function QuestLog:TitleForID(questID)
    for _, e in ipairs(self:Scan()) do
        if e.questID == questID then return e.title end
    end
    return nil
end

-- Vælg den mest relevante objektiv-linje for en mob: den ufærdige linje der
-- deler FLEST ord med mob-navnet (så "Murkblood Raider" rammer "...Raider..."
-- og ikke "...Scavenger...", selvom begge deler "Murkblood"). Ellers den
-- første ufærdige linje.
local function pickObjLine(e, name)
    local best, bestScore = nil, -1
    for _, o in ipairs(e.objectives) do
        if not o.done then
            local score = 0
            for word in name:gmatch("%a+") do
                if #word >= 4 and o.text:find(word, 1, true) then score = score + 1 end
            end
            if score > bestScore then best, bestScore = o.text, score end
        end
    end
    return best
end

-- Hvilke aktive quests tæller mobben `name` til, med objektiv-linje?
-- Matcher enten mob-navnet direkte i objektiv-teksten ELLER via quest-databasens
-- liste af tællende enheder (ou) - så kategori-mål som "Kil'sorrow Agent" fanger
-- de faktiske mobs (Kil'sorrow Deathsworn/Cultist/Spellbinder/...).
function QuestLog:MobObjectives(name)
    local res = {}
    if not name or name == "" then return res end
    for _, e in ipairs(self:Scan()) do
        if e.questID and not e.isComplete then
            local d = ns.QuestDB and ns.QuestDB[e.questID]
            local text
            if d and d.ou then
                -- Autoritativ liste: mobben tæller KUN hvis navnet står præcist i
                -- ou. (Undgår at "Clefthoof" fejlagtigt matcher "Clefthoof Bull".)
                for _, un in ipairs(d.ou) do
                    if un == name then text = pickObjLine(e, name); break end
                end
            else
                -- Ingen DB-liste: fald tilbage på mob-navn i objektiv-teksten.
                for _, o in ipairs(e.objectives) do
                    if not o.done and o.text:find(name, 1, true) then text = o.text; break end
                end
            end
            if text then
                res[#res + 1] = { title = e.title, level = e.level, text = text }
            end
        end
    end
    return res
end

-- Til item-tooltips: hvilke aktive quests skal bruge item `itemID`?
-- (fx "Air Elemental Gas" -> "I Must Have Them!"). Bruger DB'ens oi-liste.
function QuestLog:ItemObjectives(itemID, name)
    local res = {}
    itemID = tonumber(itemID)
    if not itemID then return res end
    for _, e in ipairs(self:Scan()) do
        if e.questID and not e.isComplete then
            local d = ns.QuestDB and ns.QuestDB[e.questID]
            if d and d.oi then
                for _, iid in ipairs(d.oi) do
                    if iid == itemID then
                        local text = pickObjLine(e, name or "")
                            or (e.objectives[1] and e.objectives[1].text) or ""
                        res[#res + 1] = { title = e.title, level = e.level, text = text }
                        break
                    end
                end
            end
        end
    end
    return res
end

-- Til tooltips: hvilke aktive (ufærdige) quest-objectives nævner `name`?
-- Returnerer { {title=, level=, text=}, ... }.
function QuestLog:ObjectivesForName(name)
    local res = {}
    if not name or name == "" then return res end
    for _, e in ipairs(self:Scan()) do
        if e.questID and not e.isComplete then
            for _, o in ipairs(e.objectives) do
                if not o.done and o.text:find(name, 1, true) then
                    res[#res + 1] = { title = e.title, level = e.level, text = o.text }
                end
            end
        elseif e.questID and e.isComplete then
            -- Vis også "klar til aflevering" hvis mobben er selve turn-in? (udeladt)
        end
    end
    return res
end
