-- NPC Module
-- Non-player character generation and management

local NPC = {}
NPC.__index = NPC

local settings = require("config.settings")

---
-- Create a new NPC
-- @param data table NPC base data
-- @return NPC New NPC object
function NPC.new(data)
  local self = setmetatable({}, NPC)

  -- Basic identity
  self.name = data.name or "Unknown"
  self.first_name = data.first_name
  self.last_name = data.last_name
  self.title = data.title  -- Sir, Lady, Master, etc.

  -- Fantasy attributes
  self.race = data.race or self:random_race()
  self.class = data.class or self:random_class()
  self.level = data.level or math.random(1, 10)

  -- Physical attributes
  self.gender = data.gender
  self.age = data.age
  self.portrait_url = data.portrait_url  -- Image from RandomUser API

  -- Background
  self.backstory = data.backstory
  self.personality = data.personality
  self.faction = data.faction  -- Faction affiliation

  -- Location
  self.home_location = data.home_location
  self.current_location = data.current_location

  return self
end

---
-- Select a random fantasy race
-- @return string Race name
function NPC:random_race()
  local races = settings.NPC.races
  return races[math.random(#races)]
end

---
-- Select a random character class
-- @return string Class name
function NPC:random_class()
  local classes = settings.NPC.classes
  return classes[math.random(#classes)]
end

---
-- Generate a full name with title
-- @return string Full formatted name
function NPC:full_name()
  local parts = {}

  if self.title then
    table.insert(parts, self.title)
  end

  table.insert(parts, self.name or self.first_name)

  if self.last_name and self.last_name ~= self.name then
    table.insert(parts, self.last_name)
  end

  return table.concat(parts, " ")
end

---
-- Generate NPC description
-- @return string NPC description
function NPC:describe()
  return string.format(
    "%s is a level %d %s %s",
    self:full_name(),
    self.level,
    self.race,
    self.class
  )
end

---
-- Set NPC backstory
-- @param backstory string Character backstory
function NPC:set_backstory(backstory)
  self.backstory = backstory
end

---
-- Set faction affiliation
-- @param faction string Faction name
function NPC:set_faction(faction)
  self.faction = faction
end

---
-- Convert NPC to table
-- @return table NPC data
function NPC:to_table()
  return {
    name = self:full_name(),
    race = self.race,
    class = self.class,
    level = self.level,
    gender = self.gender,
    age = self.age,
    portrait = self.portrait_url,
    backstory = self.backstory,
    personality = self.personality,
    faction = self.faction,
    location = self.current_location
  }
end

---
-- Generate multiple random NPCs
-- @param count number Number of NPCs to generate
-- @return table Array of NPC objects
function NPC.generate_batch(count)
  local npcs = {}

  -- TODO: Use RandomUser API to generate base NPC data
  -- Then enhance with fantasy attributes

  for i = 1, count do
    local npc = NPC.new({
      name = "NPC " .. i,  -- Placeholder
      race = nil,  -- Will be randomly assigned
      class = nil  -- Will be randomly assigned
    })
    table.insert(npcs, npc)
  end

  return npcs
end

return NPC
