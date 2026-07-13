local _, ns = ...

-- =========================================================================
-- Qeasy Seasonal: styrer HVORNÅR sæson-event-quests (Fire Festival, Hallow's
-- End, Noblegarden, Children's Week ...) vises på kortet. Quests i DB'en er
-- mærket med et event-tag (`ev`); her afgør vi ud fra DATOEN, om eventet er
-- aktivt. Fx forsvinder Candy Bucket uden for Hallow's End, og Fire Festival-
-- questsene dukker kun op i juni-juli.
--
-- Datoerne varierer lidt år for år (og pr. Classic-realm), så vinduerne er
-- bevidst lidt rummelige. Justér frit i WINDOWS.
-- =========================================================================

local Seasonal = {}
ns.Seasonal = Seasonal

-- Event-vindue som {startMåned, startDag, slutMåned, slutDag}. Et vindue kan
-- krydse årsskiftet (fx Winter Veil dec->jan).
local WINDOWS = {
    midsummer      = { 6, 21, 7, 5 },     -- Fire Festival
    hallowsend     = { 10, 18, 11, 1 },   -- Hallow's End
    winterveil     = { 12, 15, 1, 2 },    -- Feast of Winter Veil
    loveisintheair = { 2, 5, 2, 19 },
    childrensweek  = { 5, 1, 5, 7 },
    brewfest       = { 9, 20, 10, 6 },
    pilgrim        = { 11, 22, 11, 28 },  -- Pilgrim's Bounty
    -- Lunar Festival og Noblegarden flytter for meget (måne/påske) til et fast
    -- vindue - de udelades her og vises derfor altid (ingen dato-gate).
}

local function onOrAfter(m, d, am, ad)  return m > am or (m == am and d >= ad) end
local function onOrBefore(m, d, bm, bd) return m < bm or (m == bm and d <= bd) end

local function inWindow(w, m, d)
    if w[1] <= w[3] then
        return onOrAfter(m, d, w[1], w[2]) and onOrBefore(m, d, w[3], w[4])
    end
    -- vindue krydser årsskiftet
    return onOrAfter(m, d, w[1], w[2]) or onOrBefore(m, d, w[3], w[4])
end

-- Er et event aktivt lige nu? Ukendt/utagget event -> altid synligt.
function Seasonal:IsActive(event)
    if not event then return true end
    local w = WINDOWS[event]
    if not w then return true end
    local t = date and date("*t")           -- lokal dato { month=, day=, ... }
    if not t or not t.month then return true end
    return inWindow(w, t.month, t.day)
end

-- Skal en quest vises på kortet nu? True hvis den ikke er sæsonbestemt, eller
-- dens event er aktivt.
function Seasonal:QuestVisible(qid)
    local d = ns.QuestDB and ns.QuestDB[qid]
    if not d or not d.ev then return true end
    return self:IsActive(d.ev)
end
