--[[
    Faction System
    Handles factions, reputation, and faction effects
]]

local FactionSystem = {}
FactionSystem.factions = {}
FactionSystem.reputation = {}

-- Initialize faction system
function FactionSystem.init()
    FactionSystem.factions = {}
    FactionSystem.reputation = {}
end

-- Register a faction
function FactionSystem.registerFaction(factionId, factionData)
    FactionSystem.factions[factionId] = factionData
    FactionSystem.reputation[factionId] = 0
end

-- Change reputation
function FactionSystem.changeReputation(factionId, amount)
    if not FactionSystem.reputation[factionId] then
        return false
    end

    FactionSystem.reputation[factionId] = FactionSystem.reputation[factionId] + amount
    return true
end

-- Get reputation
function FactionSystem.getReputation(factionId)
    return FactionSystem.reputation[factionId] or 0
end

-- Get reputation level
function FactionSystem.getReputationLevel(factionId)
    local rep = FactionSystem.getReputation(factionId)

    if rep < -50 then
        return "hated"
    elseif rep < -20 then
        return "hostile"
    elseif rep < 20 then
        return "neutral"
    elseif rep < 50 then
        return "friendly"
    else
        return "honored"
    end
end

return FactionSystem

