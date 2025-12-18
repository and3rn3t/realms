-- Realm Module
-- Main class representing a generated fantasy realm

local Realm = {}
Realm.__index = Realm

local json = require("src.utils.json")
local settings = require("config.settings")

---
-- Create a new Realm instance
-- @param config table Configuration for the realm
-- @return Realm New realm object
function Realm.new(config)
  local self = setmetatable({}, Realm)

  -- Basic realm properties
  self.name = nil                    -- Fantasy realm name
  self.address = config.address      -- Original real-world address
  self.center = {lat = nil, lon = nil}  -- Center coordinates
  self.radius = config.radius        -- Radius in km
  self.bounding_box = nil            -- Geographic bounds

  -- Geographic data
  self.locations = {}                -- Array of Location objects
  self.terrain_types = {}            -- Terrain classification results
  self.climate = nil                 -- Climate data

  -- Fantasy elements
  self.npcs = {}                     -- Array of NPC objects
  self.factions = {}                 -- Array of Faction objects
  self.quests = {}                   -- Array of Quest objects
  self.lore = {}                     -- Lore and backstory

  -- Metadata
  self.created_at = os.time()
  self.version = "1.0"

  return self
end

---
-- Set the realm's name
-- @param name string Fantasy name for the realm
function Realm:set_name(name)
  self.name = name
end

---
-- Add a location to the realm
-- @param location Location Location object
function Realm:add_location(location)
  table.insert(self.locations, location)
end

---
-- Add an NPC to the realm
-- @param npc NPC NPC object
function Realm:add_npc(npc)
  table.insert(self.npcs, npc)
end

---
-- Add a faction to the realm
-- @param faction Faction Faction object
function Realm:add_faction(faction)
  table.insert(self.factions, faction)
end

---
-- Add a quest to the realm
-- @param quest Quest Quest object
function Realm:add_quest(quest)
  table.insert(self.quests, quest)
end

---
-- Add lore entry
-- @param lore_entry table Lore data
function Realm:add_lore(lore_entry)
  table.insert(self.lore, lore_entry)
end

---
-- Get realm statistics
-- @return table Statistics about the realm
function Realm:get_stats()
  return {
    location_count = #self.locations,
    npc_count = #self.npcs,
    faction_count = #self.factions,
    quest_count = #self.quests,
    terrain_types = self:count_terrain_types()
  }
end

---
-- Count terrain types in the realm
-- @return table Count of each terrain type
function Realm:count_terrain_types()
  local counts = {}
  for _, location in ipairs(self.locations) do
    if location.terrain_type then
      counts[location.terrain_type] = (counts[location.terrain_type] or 0) + 1
    end
  end
  return counts
end

---
-- Convert realm to JSON string
-- @return string JSON representation
function Realm:to_json()
  -- TODO: Implement JSON serialization
  return json.encode(self)
end

---
-- Convert realm to Lua table
-- @return table Lua table representation
function Realm:to_table()
  return {
    name = self.name,
    address = self.address,
    center = self.center,
    radius = self.radius,
    locations = self.locations,
    terrain_types = self.terrain_types,
    climate = self.climate,
    npcs = self.npcs,
    factions = self.factions,
    quests = self.quests,
    lore = self.lore,
    stats = self:get_stats(),
    created_at = self.created_at,
    version = self.version
  }
end

---
-- Generate a summary of the realm
-- @return string Human-readable summary
function Realm:summary()
  local summary = string.format(
    "=== %s ===\n" ..
    "Based on: %s\n" ..
    "Locations: %d\n" ..
    "NPCs: %d\n" ..
    "Factions: %d\n" ..
    "Quests: %d\n",
    self.name or "Unnamed Realm",
    self.address,
    #self.locations,
    #self.npcs,
    #self.factions,
    #self.quests
  )

  return summary
end

return Realm
