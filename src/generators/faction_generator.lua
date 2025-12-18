-- Faction Generator
-- Generate kingdoms, guilds, and other organizations

local faction_generator = {}

local settings = require("config.settings")
local name_generator = require("src.generators.name_generator")

---
-- Generate a faction
-- @param faction_type string Type of faction (Kingdom, Guild, etc.)
-- @param realm Realm Realm context
-- @return table Faction data
function faction_generator.generate(faction_type, realm)
  faction_type = faction_type or settings.FACTION_TYPES[math.random(#settings.FACTION_TYPES)]

  local faction = {
    name = name_generator.generate_faction_name(),
    type = faction_type,
    leader = nil,           -- Will be an NPC
    headquarters = nil,     -- Location
    members_count = math.random(50, 5000),
    alignment = faction_generator.random_alignment(),
    goals = {},
    relationships = {},     -- Relations with other factions
    resources = {},
    influence = math.random(1, 10)
  }

  -- TODO: Generate faction details
  -- 1. Assign leader NPC
  -- 2. Determine headquarters location
  -- 3. Generate goals and motivations
  -- 4. Create faction history
  -- 5. Establish relationships with other factions

  return faction
end

---
-- Generate multiple factions for a realm
-- @param count number Number of factions to generate
-- @param realm Realm Realm context
-- @return table Array of factions
function faction_generator.generate_multiple(count, realm)
  local factions = {}

  for i = 1, count do
    local faction = faction_generator.generate(nil, realm)
    table.insert(factions, faction)
  end

  -- TODO: Establish relationships between factions
  -- Some are allies, some are rivals, some are at war

  return factions
end

---
-- Generate random alignment
-- @return string Faction alignment
function faction_generator.random_alignment()
  local alignments = {
    "Lawful Good", "Neutral Good", "Chaotic Good",
    "Lawful Neutral", "True Neutral", "Chaotic Neutral",
    "Lawful Evil", "Neutral Evil", "Chaotic Evil"
  }
  return alignments[math.random(#alignments)]
end

---
-- Generate faction goals
-- @param faction_type string Type of faction
-- @return table Array of goals
function faction_generator.generate_goals(faction_type)
  -- TODO: Generate type-specific goals
  -- Kingdom: Expansion, defense, prosperity
  -- Guild: Profit, influence, monopoly
  -- Cult: Convert followers, summon entity, gain power
  -- Order: Maintain balance, protect realm, uphold code

  local goals = {
    "Expand territory and influence",
    "Accumulate wealth and resources",
    "Protect members and allies"
  }

  return goals
end

---
-- Establish relationship between two factions
-- @param faction1 table First faction
-- @param faction2 table Second faction
-- @return string Relationship type
function faction_generator.establish_relationship(faction1, faction2)
  -- TODO: Determine relationship based on:
  -- - Faction types
  -- - Alignments
  -- - Goals
  -- - Geography

  local relationships = {
    "allied", "friendly", "neutral", "tense", "rival", "at_war"
  }

  return relationships[math.random(#relationships)]
end

---
-- Generate faction resources
-- @param faction_type string Type of faction
-- @return table Resources
function faction_generator.generate_resources(faction_type)
  -- TODO: Generate faction resources
  -- Gold, troops, magic items, artifacts, knowledge, etc.

  return {
    gold = math.random(1000, 100000),
    troops = math.random(100, 10000),
    magic_items = math.random(0, 50)
  }
end

return faction_generator
