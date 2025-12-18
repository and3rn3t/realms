-- Quest Generator
-- Generate quests and adventures for the realm

local quest_generator = {}

local settings = require("config.settings")
local name_generator = require("src.generators.name_generator")

---
-- Generate a quest
-- @param difficulty string Quest difficulty (EASY, MEDIUM, HARD, LEGENDARY)
-- @param realm Realm Realm context
-- @return table Quest data
function quest_generator.generate(difficulty, realm)
  difficulty = difficulty or "MEDIUM"

  local quest_types = {
    "retrieval", "rescue", "elimination", "escort", "investigation",
    "defense", "exploration", "diplomatic", "crafting", "mystery"
  }

  local quest = {
    title = name_generator.generate_quest_name(),
    type = quest_types[math.random(#quest_types)],
    difficulty = difficulty,
    level = settings.QUEST_DIFFICULTIES[difficulty].level,
    description = nil,
    objectives = {},
    rewards = {},
    giver = nil,        -- NPC who gives the quest
    location = nil,     -- Where quest takes place
    enemies = {},       -- Enemies to face
    time_limit = nil    -- Optional time constraint
  }

  -- TODO: Generate quest details
  -- 1. Create description
  -- 2. Generate objectives
  -- 3. Determine rewards based on difficulty
  -- 4. Assign quest giver NPC
  -- 5. Select location
  -- 6. Add enemies if combat quest

  return quest
end

---
-- Generate multiple quests for a realm
-- @param count number Number of quests to generate
-- @param realm Realm Realm context
-- @return table Array of quests
function quest_generator.generate_multiple(count, realm)
  local quests = {}

  -- Generate quests of various difficulties
  local difficulties = {"EASY", "EASY", "MEDIUM", "MEDIUM", "HARD", "LEGENDARY"}

  for i = 1, count do
    local difficulty = difficulties[math.random(#difficulties)]
    local quest = quest_generator.generate(difficulty, realm)
    table.insert(quests, quest)
  end

  return quests
end

---
-- Generate quest objectives
-- @param quest_type string Type of quest
-- @param count number Number of objectives
-- @return table Array of objectives
function quest_generator.generate_objectives(quest_type, count)
  count = count or math.random(1, 3)

  -- TODO: Generate type-specific objectives
  -- retrieval: "Find the Ancient Tome"
  -- rescue: "Save the village elder"
  -- elimination: "Defeat 10 goblins"
  -- etc.

  return {}
end

---
-- Generate quest rewards
-- @param difficulty string Quest difficulty
-- @return table Rewards
function quest_generator.generate_rewards(difficulty)
  local multiplier = settings.QUEST_DIFFICULTIES[difficulty].reward_multiplier

  local rewards = {
    gold = math.random(100, 500) * multiplier,
    experience = math.random(500, 2000) * multiplier,
    items = {},
    reputation = math.random(10, 50) * multiplier
  }

  -- TODO: Add magic items for higher difficulty quests
  -- Use D&D API to select appropriate items

  return rewards
end

---
-- Generate a quest chain (series of related quests)
-- @param length number Number of quests in the chain
-- @param realm Realm Realm context
-- @return table Array of related quests
function quest_generator.generate_chain(length, realm)
  length = length or 3
  local chain = {}

  -- TODO: Generate connected quests
  -- Each quest leads to the next
  -- Increasing difficulty
  -- Common storyline

  for i = 1, length do
    local difficulty = i <= 1 and "EASY" or (i <= 2 and "MEDIUM" or "HARD")
    local quest = quest_generator.generate(difficulty, realm)
    quest.chain_position = i
    quest.chain_length = length
    table.insert(chain, quest)
  end

  return chain
end

---
-- Generate quest description
-- @param quest table Quest data
-- @return string Quest description
function quest_generator.generate_description(quest)
  -- TODO: Generate engaging quest description
  -- Use quest type, difficulty, location, and objectives
  -- Could use HuggingFace API for AI-generated descriptions

  return string.format(
    "A %s difficulty %s quest awaits brave adventurers.",
    quest.difficulty,
    quest.type
  )
end

---
-- Link quest to location
-- @param quest table Quest data
-- @param location Location Location object
function quest_generator.set_location(quest, location)
  quest.location = location
  -- TODO: Ensure quest type is appropriate for location
end

---
-- Link quest to NPC
-- @param quest table Quest data
-- @param npc NPC NPC object
function quest_generator.set_giver(quest, npc)
  quest.giver = npc
end

return quest_generator
